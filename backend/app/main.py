from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, Literal

app = FastAPI(title="StormTune — v1.0 API")

# CORS for dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ===== Models =====
class Ambient(BaseModel):
    temp_c: float
    humidity_pct: Optional[float] = None
    baro_hpa: Optional[float] = None
    iat_c: Optional[float] = None
    clt_c: Optional[float] = None

class Track(BaseModel):
    surface: Literal["asphalt","concrete","gravel","snow","tarmac"] = "asphalt"
    condition: Literal["dry","damp","wet"] = "dry"
    prep: Literal["unprepped","light","heavy"] = "unprepped"
    track_temp_c: Optional[float] = None

class Vehicle(BaseModel):
    drive: Literal["FWD","RWD","AWD"] = "FWD"
    induction: Literal["na","turbo","supercharged"] = "turbo"
    fuel: Literal["Pump","E85","Race"] = "Pump"
    tire: Literal["street","drag_radial","slick","semislick","rally"] = "drag_radial"
    weight_class: Literal["light","mid","heavy"] = "mid"
    ignition_strength: Optional[Literal["OEM","SmartCoils","CDI"]] = "OEM"

class Baseline(BaseModel):
    launch_rpm: int = 5500
    base_wgdc_pct: Optional[float] = 55.0
    afr_target_wot: Optional[float] = 11.8
    tire_hot_pressure_psi: Optional[float] = 16.0
    boost_psi: Optional[float] = 12.0

class RequestPayload(BaseModel):
    race_mode: Literal["street","drag","drift","circuit","rally"] = "street"
    basic_mode: bool = True
    ecu_brand: Optional[str] = None
    ambient: Ambient
    track: Track
    vehicle: Vehicle
    baseline: Baseline

# ===== Core calcs =====
def air_density_ocf(ambient: Ambient) -> float:
    if ambient.baro_hpa is not None and ambient.temp_c is not None:
        p_pa = ambient.baro_hpa * 100.0
        T_k = ambient.temp_c + 273.15
        rho = p_pa / (287.05 * T_k)
        rho_ref = 1.184
        return rho / rho_ref
    return 1.0

def ignition_trim_deg(temp_c: float, induction: str, fuel: str, humidity_pct: Optional[float]) -> float:
    base = 25.0
    slope = 0.2 if induction == "turbo" else 0.1
    trim = -(max(0.0, (temp_c - base)) * slope)
    if (humidity_pct or 0) >= 75 and fuel == "Pump":
        trim -= 0.5
    return max(trim, -4.0)

def wgdc_trim_pct(ocf: float, k: float = 0.6) -> float:
    if ocf <= 0: return 0.0
    inv = (1.0 / max(0.85, ocf)) - 1.0
    return inv * k * 100.0

def grip_index(track: Track, vehicle: Vehicle) -> float:
    gi = 1.0
    if track.surface == "concrete": gi += 0.05
    if track.surface in ("gravel","snow"): gi -= 0.15
    if track.condition == "damp": gi -= 0.15
    if track.condition == "wet": gi -= 0.30
    tt = track.track_temp_c
    if tt is not None:
        if 35 <= tt <= 50: gi += 0.05
        if tt < 15 or tt > 55: gi -= 0.05
    if vehicle.tire == "slick": gi += 0.10
    elif vehicle.tire == "drag_radial": gi += 0.05
    elif vehicle.tire == "street": gi -= 0.02
    elif vehicle.tire == "rally": gi -= 0.05
    return gi

def launch_rpm_adjust(baseline_rpm: int, gi: float) -> int:
    adj = -(1.0 - gi) * 0.25
    adj = min(0.10, max(-0.20, adj))
    return int(round(baseline_rpm * (1.0 + adj), -1))

def antilag_level(gi: float, vehicle: Vehicle, race_mode: str) -> str:
    if vehicle.induction != "turbo": return "off"
    if race_mode in ("rally","drift"):
        return "high" if gi >= 1.0 else "medium"
    if gi < 0.9: return "low"
    if gi > 1.05: return "high"
    return "medium"

def tire_pressure_recommend(baseline_hot: Optional[float], track: Track, vehicle: Vehicle, race_mode: str) -> Optional[float]:
    if baseline_hot is None: return None
    delta = 0.0
    tt = track.track_temp_c or 25.0
    if track.condition == "wet": delta -= 0.5
    elif track.condition == "damp": delta -= 0.2
    if tt < 15: delta -= 0.5
    elif tt > 55: delta += 0.3
    elif 35 <= tt <= 50: delta += 0.2
    if race_mode == "drag":
        if vehicle.tire in ("drag_radial","slick"): delta -= 0.3
    elif race_mode == "circuit":
        delta += 0.1
    elif race_mode == "rally":
        if track.surface in ("gravel","snow"): delta -= 0.4
    return round(baseline_hot + delta, 1)

# ===== SparkGap Advisory =====
def spark_gap_advice(iat_c: Optional[float], clt_c: Optional[float], boost_psi: Optional[float], fuel: str, mode: str, ignition_strength: Optional[str]) -> dict:
    # Base band in inches for moderate boost/temps on Pump fuel with OEM ignition
    low, high = 0.022, 0.026

    # Boost effect
    if boost_psi is not None:
        if boost_psi >= 24: low, high = 0.018, 0.022
        elif boost_psi >= 18: low, high = 0.020, 0.024
        elif boost_psi >= 12: low, high = 0.022, 0.026
        else: low, high = 0.024, 0.028

    # IAT heat tightens gap
    if iat_c is not None and iat_c >= 50:  # ≥122F
        low -= 0.001; high -= 0.001

    # Fuel effect
    if fuel == "E85": 
        low += 0.001; high += 0.001
    elif fuel == "Race": 
        low += 0.000; high += 0.001

    # Mode effect
    if mode in ("drag","rally"):  # prioritize stability
        high -= 0.001
    elif mode == "street":        # drivability
        high += 0.001

    # Ignition strength
    if ignition_strength == "SmartCoils":
        low += 0.001; high += 0.001
    elif ignition_strength == "CDI":
        low += 0.002; high += 0.002

    # Clamp
    low = max(0.016, min(low, 0.030))
    high = max(low + 0.001, min(high, 0.032))

    return {
        "gap_in": [round(low, 3), round(high, 3)],
        "gap_mm": [round(low*25.4, 2), round(high*25.4, 2)],
        "notes": [
            "Tighten gap for higher boost/heat to reduce blowout.",
            "Widen gap for light boost/cool temps to improve efficiency.",
            f"Fuel: {fuel}, Mode: {mode}, Ignition: {ignition_strength or 'OEM'}"
        ]
    }

# ===== Endpoints =====
@app.post("/api/recommend")
def recommend(payload: RequestPayload):
    ocf = air_density_ocf(payload.ambient)
    fuel_trim = max(-6.0, min(6.0, (ocf - 1.0) * 100.0))
    ign_trim = ignition_trim_deg(payload.ambient.temp_c, payload.vehicle.induction, payload.vehicle.fuel, payload.ambient.humidity_pct)
    wgdc_trim = max(-10.0, min(10.0, wgdc_trim_pct(ocf)))
    gi = grip_index(payload.track, payload.vehicle)
    new_launch = launch_rpm_adjust(payload.baseline.launch_rpm, gi)
    anti = antilag_level(gi, payload.vehicle, payload.race_mode)
    tire_hot = tire_pressure_recommend(payload.baseline.tire_hot_pressure_psi, payload.track, payload.vehicle, payload.race_mode)
    spark = spark_gap_advice(payload.ambient.iat_c, payload.ambient.clt_c, payload.baseline.boost_psi, payload.vehicle.fuel, payload.race_mode, payload.vehicle.ignition_strength)

    insights = {
        "drag": f"Grip {gi:.2f}. Expect better 60‑ft if ≥1.0; launch {new_launch} rpm.",
        "circuit": "Balance pressures and temps; aim for consistency.",
        "drift": "Stabilize slip with gentle torque steps & timing control.",
        "rally": "Traction-first maps; anti-lag for response; watch EGT.",
        "street": "Smooth drivability and safety margins prioritized."
    }

    return {
        "race_mode": payload.race_mode,
        "corrections": {
            "launch_rpm": new_launch,
            "fuel_trim_pct": round(fuel_trim, 1),
            "ignition_trim_deg": round(ign_trim, 1),
            "wgdc_trim_pct": round(wgdc_trim, 1),
            "antilag": anti,
            "tire_pressure_hot_psi": tire_hot
        },
        "spark_gap": spark,
        "insight": insights[payload.race_mode]
    }

@app.get("/")
def index():
    html = """
    <html><head><title>StormTune v1.0</title></head>
    <body style="font-family:system-ui;margin:2rem;max-width:900px">
      <h1>StormTune v1.0 — API OK</h1>
      <p>POST <code>/api/recommend</code> to get recommendations and SparkGap advice.</p>
    </body></html>
    """
    return HTMLResponse(html)
