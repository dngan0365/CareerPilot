from fastapi import FastAPI
 
app = FastAPI(title="User Service")
 
@app.get("/health")
def health():
    return {"status": "ok", "service": "user_service"}
 
@app.get("/")
def root():
    return {"message": "User Service is running"}
 