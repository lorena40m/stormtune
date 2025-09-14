from fastapi import APIRouter
from fastapi.responses import HTMLResponse
from schemas import RequestPayload
from core.calculations import (
	air_density_ocf,
	ignition_trim_deg,
	wgdc_trim_pct,
	grip_index,
	launch_rpm_adjust,
	antilag_level,
	tire_pressure_recommend,
	spark_gap_advice,
)

router = APIRouter()


@router.post("/api/recommend")
def recommend(payload: RequestPayload):
	ocf = air_density_ocf(payload.ambient)
	fuel_trim = max(-6.0, min(6.0, (ocf - 1.0) * 100.0))
	ign_trim = ignition_trim_deg(
		payload.ambient.temp_c, payload.vehicle.induction, payload.vehicle.fuel, payload.ambient.humidity_pct
	)
	wgdc_trim = max(-10.0, min(10.0, wgdc_trim_pct(ocf)))
	gi = grip_index(payload.track, payload.vehicle)
	new_launch = launch_rpm_adjust(payload.baseline.launch_rpm, gi)
	anti = antilag_level(gi, payload.vehicle, payload.race_mode)
	tire_hot = tire_pressure_recommend(
		payload.baseline.tire_hot_pressure_psi, payload.track, payload.vehicle, payload.race_mode
	)
	spark = spark_gap_advice(
		payload.ambient.iat_c,
		payload.ambient.clt_c,
		payload.baseline.boost_psi,
		payload.vehicle.fuel,
		payload.race_mode,
		payload.vehicle.ignition_strength,
	)
	insights = {
		"drag": f"Grip {gi:.2f}. Expect better 60‑ft if ≥1.0; launch {new_launch} rpm.",
		"circuit": "Balance pressures and temps; aim for consistency.",
		"drift": "Stabilize slip with gentle torque steps & timing control.",
		"rally": "Traction-first maps; anti-lag for response; watch EGT.",
		"street": "Smooth drivability and safety margins prioritized.",
	}
	return {
		"race_mode": payload.race_mode,
		"corrections": {
			"launch_rpm": new_launch,
			"fuel_trim_pct": round(fuel_trim, 1),
			"ignition_trim_deg": round(ign_trim, 1),
			"wgdc_trim_pct": round(wgdc_trim, 1),
			"antilag": anti,
			"tire_pressure_hot_psi": tire_hot,
		},
		"spark_gap": spark,
		"insight": insights[payload.race_mode],
	}


@router.get("/")
def index():
	html = """
	<html><head><title>StormTune v1.0</title></head>
	<body style="font-family:system-ui;margin:2rem;max-width:900px">
	  <h1>StormTune v1.0 — API OK</h1>
	  <p>POST <code>/api/recommend</code> to get recommendations and SparkGap advice.</p>
	</body></html>
	"""
	return HTMLResponse(html) 