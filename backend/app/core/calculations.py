from typing import Optional
from schemas import Ambient, Track, Vehicle


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
	if ocf <= 0:
		return 0.0
	inv = (1.0 / max(0.85, ocf)) - 1.0
	return inv * k * 100.0


def grip_index(track: Track, vehicle: Vehicle) -> float:
	gi = 1.0
	if track.surface == "concrete":
		gi += 0.05
	if track.surface in ("gravel", "snow"):
		gi -= 0.15
	if track.condition == "damp":
		gi -= 0.15
	if track.condition == "wet":
		gi -= 0.30
	tt = track.track_temp_c
	if tt is not None:
		if 35 <= tt <= 50:
			gi += 0.05
		if tt < 15 or tt > 55:
			gi -= 0.05
	if vehicle.tire == "slick":
		gi += 0.10
	elif vehicle.tire == "drag_radial":
		gi += 0.05
	elif vehicle.tire == "street":
		gi -= 0.02
	elif vehicle.tire == "rally":
		gi -= 0.05
	return gi


def launch_rpm_adjust(baseline_rpm: int, gi: float) -> int:
	adj = -(1.0 - gi) * 0.25
	adj = min(0.10, max(-0.20, adj))
	return int(round(baseline_rpm * (1.0 + adj), -1))


def antilag_level(gi: float, vehicle: Vehicle, race_mode: str) -> str:
	if vehicle.induction != "turbo":
		return "off"
	if race_mode in ("rally", "drift"):
		return "high" if gi >= 1.0 else "medium"
	if gi < 0.9:
		return "low"
	if gi > 1.05:
		return "high"
	return "medium"


def tire_pressure_recommend(baseline_hot: Optional[float], track: Track, vehicle: Vehicle, race_mode: str) -> Optional[float]:
	if baseline_hot is None:
		return None
	delta = 0.0
	tt = track.track_temp_c or 25.0
	if track.condition == "wet":
		delta -= 0.5
	elif track.condition == "damp":
		delta -= 0.2
	if tt < 15:
		delta -= 0.5
	elif tt > 55:
		delta += 0.3
	elif 35 <= tt <= 50:
		delta += 0.2
	if race_mode == "drag":
		if vehicle.tire in ("drag_radial", "slick"):
			delta -= 0.3
	elif race_mode == "circuit":
		delta += 0.1
	elif race_mode == "rally":
		if track.surface in ("gravel", "snow"):
			delta -= 0.4
	return round(baseline_hot + delta, 1)


def spark_gap_advice(iat_c: Optional[float], clt_c: Optional[float], boost_psi: Optional[float], fuel: str, mode: str, ignition_strength: Optional[str]) -> dict:
	low, high = 0.022, 0.026
	if boost_psi is not None:
		if boost_psi >= 24:
			low, high = 0.018, 0.022
		elif boost_psi >= 18:
			low, high = 0.020, 0.024
		elif boost_psi >= 12:
			low, high = 0.022, 0.026
		else:
			low, high = 0.024, 0.028
	if iat_c is not None and iat_c >= 50:
		low -= 0.001
		high -= 0.001
	if fuel == "E85":
		low += 0.001
		high += 0.001
	elif fuel == "Race":
		low += 0.000
		high += 0.001
	if mode in ("drag", "rally"):
		high -= 0.001
	elif mode == "street":
		high += 0.001
	if ignition_strength == "SmartCoils":
		low += 0.001
		high += 0.001
	elif ignition_strength == "CDI":
		low += 0.002
		high += 0.002
	low = max(0.016, min(low, 0.030))
	high = max(low + 0.001, min(high, 0.032))
	return {
		"gap_in": [round(low, 3), round(high, 3)],
		"gap_mm": [round(low * 25.4, 2), round(high * 25.4, 2)],
		"notes": [
			"Tighten gap for higher boost/heat to reduce blowout.",
			"Widen gap for light boost/cool temps to improve efficiency.",
			f"Fuel: {fuel}, Mode: {mode}, Ignition: {ignition_strength or 'OEM'}",
		],
	} 