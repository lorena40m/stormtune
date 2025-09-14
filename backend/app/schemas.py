from pydantic import BaseModel
from typing import Optional, Literal


class Ambient(BaseModel):
	temp_c: float
	humidity_pct: Optional[float] = None
	baro_hpa: Optional[float] = None
	iat_c: Optional[float] = None
	clt_c: Optional[float] = None


class Track(BaseModel):
	surface: Literal["asphalt", "concrete", "gravel", "snow", "tarmac"] = "asphalt"
	condition: Literal["dry", "damp", "wet"] = "dry"
	prep: Literal["unprepped", "light", "heavy"] = "unprepped"
	track_temp_c: Optional[float] = None


class Vehicle(BaseModel):
	drive: Literal["FWD", "RWD", "AWD"] = "FWD"
	induction: Literal["na", "turbo", "supercharged"] = "turbo"
	fuel: Literal["Pump", "E85", "Race"] = "Pump"
	tire: Literal["street", "drag_radial", "slick", "semislick", "rally"] = "drag_radial"
	weight_class: Literal["light", "mid", "heavy"] = "mid"
	ignition_strength: Optional[Literal["OEM", "SmartCoils", "CDI"]] = "OEM"


class Baseline(BaseModel):
	launch_rpm: int = 5500
	base_wgdc_pct: Optional[float] = 55.0
	afr_target_wot: Optional[float] = 11.8
	tire_hot_pressure_psi: Optional[float] = 16.0
	boost_psi: Optional[float] = 12.0


class RequestPayload(BaseModel):
	race_mode: Literal["street", "drag", "drift", "circuit", "rally"] = "street"
	basic_mode: bool = True
	ecu_brand: Optional[str] = None
	ambient: Ambient
	track: Track
	vehicle: Vehicle
	baseline: Baseline 