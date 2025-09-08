import math
from app.main import spark_gap_advice

def test_spark_gap_low_boost_cool():
    s = spark_gap_advice(iat_c=10, clt_c=80, boost_psi=8, fuel="Pump", mode="street", ignition_strength="OEM")
    lo, hi = s["gap_in"]
    assert 0.023 <= lo <= 0.025
    assert 0.027 >= hi >= 0.025

def test_spark_gap_high_boost_hot():
    s = spark_gap_advice(iat_c=60, clt_c=95, boost_psi=26, fuel="Pump", mode="drag", ignition_strength="OEM")
    lo, hi = s["gap_in"]
    assert lo <= 0.019 and hi <= 0.022

def test_spark_gap_ignition_strengths():
    s_cdi = spark_gap_advice(iat_c=30, clt_c=90, boost_psi=18, fuel="E85", mode="circuit", ignition_strength="CDI")
    s_oem = spark_gap_advice(iat_c=30, clt_c=90, boost_psi=18, fuel="E85", mode="circuit", ignition_strength="OEM")
    assert s_cdi["gap_in"][0] > s_oem["gap_in"][0]
