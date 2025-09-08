from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def payload(**over):
    base = {
        "race_mode": "street",
        "basic_mode": True,
        "ecu_brand": None,
        "ambient": {"temp_c": 25, "humidity_pct": 60, "baro_hpa": 1013, "iat_c": 35, "clt_c": 90},
        "track": {"surface":"asphalt","condition":"dry","prep":"unprepped","track_temp_c":30},
        "vehicle": {"drive":"RWD","induction":"turbo","fuel":"Pump","tire":"drag_radial","weight_class":"mid","ignition_strength":"OEM"},
        "baseline": {"launch_rpm":5500,"base_wgdc_pct":55,"afr_target_wot":11.8,"tire_hot_pressure_psi":16,"boost_psi":12}
    }
    base.update(over)
    return base

def test_recommend_200():
    r = client.post("/api/recommend", json=payload())
    assert r.status_code == 200
    j = r.json()
    assert "corrections" in j and "spark_gap" in j
    assert isinstance(j["spark_gap"]["gap_in"], list)
