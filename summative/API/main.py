from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, confloat
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import numpy as np
import joblib

# Load the trained model
model = joblib.load("../linear_regression/best_decision_tree_model.pkl")

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

# Define request body with constraints
class PredictionRequest(BaseModel):
    attendance: float  # Attendance percentage (0-100)
    midterm_score: float  # Midterm score (0-100)
    final_score: float  # Final score (0-100)
    assignments_avg: float  # Assignments average (0-100)
    quizzes_avg: float  # Quizzes average (0-100)
    participation_score: float  # Participation score (0-10)
    projects_score: float  # Projects score (0-100)
    total_score: float  # Total score (0-100)
    study_hours_per_week: float  # Study hours per week (0-100)
    stress_level: float  # Stress level (1-10)
    sleep_hours_per_night: float  # Sleep hours per night (0-24)

@app.post("/predict")
def predict(data: PredictionRequest):
    try:
        # Convert request data to NumPy array
        input_data = np.array([[
            data.attendance, data.midterm_score, data.final_score,
            data.assignments_avg, data.quizzes_avg, data.participation_score,
            data.projects_score, data.total_score, data.study_hours_per_week,
            data.stress_level, data.sleep_hours_per_night
        ]])
        prediction = model.predict(input_data)
        return {"prediction": prediction.tolist()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)