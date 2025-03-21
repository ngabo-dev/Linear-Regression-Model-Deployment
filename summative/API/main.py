from fastapi import FastAPI
from pydantic import BaseModel, Field, conint, confloat
import uvicorn
import numpy as np
import joblib
from fastapi.middleware.cors import CORSMiddleware

# Load trained model (ensure the path is correct)
model = joblib.load("../linear_regression/best_model.pkl")

# Initialize FastAPI app
app = FastAPI(
    title="Student Performance Prediction API",
    description="An API to predict student performance based on various academic and personal factors.",
    version="1.0"
)

# Enable CORS (adjust allowed origins if necessary)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development; specify domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define input data structure
class StudentPerformanceInput(BaseModel):
    Attendance: float = Field(..., ge=0, le=100)
    Midterm_Score: int = Field(..., ge=0, le=100)
    Assignments_Avg: int = Field(..., ge=0, le=100)
    Quizzes_Avg: int = Field(..., ge=0, le=100)
    Participation_Score: int = Field(..., ge=0, le=100)
    Projects_Score: int = Field(..., ge=0, le=100)
    Study_Hours_per_Week: int = Field(..., ge=0, le=40)
    Stress_Level: int = Field(..., ge=1, le=10)
    Sleep_Hours_per_Night: float = Field(..., ge=3, le=10)

    class Config:
        schema_extra = {
            "example": {
                "Attendance": 90.5,
                "Midterm_Score": 85,
                "Assignments_Avg": 88,
                "Quizzes_Avg": 92,
                "Participation_Score": 80,
                "Projects_Score": 95,
                "Study_Hours_per_Week": 15,
                "Stress_Level": 5,
                "Sleep_Hours_per_Night": 7.5
            }
        }

# Define API endpoint for predictions
@app.post("/predict")
def predict(data: StudentPerformanceInput):
    input_data = np.array([[ 
        data.Attendance, 
        data.Midterm_Score, 
        data.Assignments_Avg, 
        data.Quizzes_Avg, 
        data.Participation_Score, 
        data.Projects_Score, 
        data.Study_Hours_per_Week, 
        data.Stress_Level, 
        data.Sleep_Hours_per_Night
    ]])
    
    prediction = model.predict(input_data)
    return {"predicted_final_score": float(prediction[0])}

# Run the API
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)