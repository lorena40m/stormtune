from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.routes import router
from core.calculations import spark_gap_advice as _spark_gap_advice

def create_app() -> FastAPI:
	app = FastAPI(title="StormTune — v1.0 API")
	app.add_middleware(
		CORSMiddleware,
		allow_origins=["*"],
		allow_credentials=True,
		allow_methods=["*"],
		allow_headers=["*"],
	)
	app.include_router(router)
	return app


# Keep compatibility for existing imports in tests
app = create_app()
spark_gap_advice = _spark_gap_advice
