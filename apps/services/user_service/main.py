in · PY
Copy

from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
 
app = FastAPI(title="User Service")
 
# Expose /metrics for Prometheus scraping
Instrumentator().instrument(app).expose(app)
 
@app.get("/health")
def health():
    return {"status": "ok", "service": "user_service"}
 
@app.get("/")
def root():
    return {"message": "User Service is running"}