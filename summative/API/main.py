from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import numpy as np
import joblib
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)

# Load the trained model with a verified path
model_path = os.path.abspath("../linear_regression/Linear_Regression_model.pkl")
if not os.path.exists(model_path):
    raise FileNotFoundError(f"Model file not found at {model_path}")

model = joblib.load(model_path)

# Get the expected number of features
expected_features = model.n_features_in_
logging.info(f"Model expects {expected_features} features.")

# Initialize FastAPI app
app = FastAPI(title="Linear Regression Prediction API")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define request body with corrected float types
class PredictionRequest(BaseModel):
    attendance: float
    midterm_score: float
    assignments_avg: float
    quizzes_avg: float
    participation_score: float
    projects_score: float
    study_hours_per_week: float
    stress_level: float
    sleep_hours_per_night: float

@app.get("/")
def read_root():
    return {"message": "API is running"}

@app.post("/predict")
def predict(data: PredictionRequest):
    try:
        # Convert input data to NumPy array and reshape
        input_data = np.array([
            data.attendance, data.midterm_score, data.assignments_avg, 
            data.quizzes_avg, data.participation_score,
            data.projects_score, data.study_hours_per_week,
            data.stress_level, data.sleep_hours_per_night
        ]).reshape(1, -1)

        # Logging for debugging
        logging.info(f"Received input data: {input_data}, Shape: {input_data.shape}")

        # Check if the input matches the expected feature count
        if input_data.shape[1] != expected_features:
            error_msg = f"Feature mismatch: Model expects {expected_features} features, but received {input_data.shape[1]}"
            logging.error(error_msg)
            raise HTTPException(status_code=400, detail=error_msg)

        # Make prediction
        prediction = model.predict(input_data)
        logging.info(f"Prediction result: {prediction.tolist()}")

        return {"prediction": prediction.tolist()}
    except Exception as e:
        logging.error(f"Prediction error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)