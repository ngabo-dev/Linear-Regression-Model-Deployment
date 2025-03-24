## Student Performance Prediction API


# Overview

This API predicts the final performance score of students based on various input parameters like attendance, midterm score, assignment averages, stress level, and more. The API uses a trained machine learning model to generate predictions.

The API is publicly available and can be accessed via the endpoint provided below. The application also includes Swagger UI for testing and interacting with the API.

# API Endpoint
# URL:
https://linear-regression-model-1-ocmt.onrender.com

# Method:
POST

# Request Body:
```json
{
  "attendance": 52.29,
  "midterm_score": 55.03,
  "assignments_avg": 84.22,
  "quizzes_avg": 74.06,
  "participation_score": 3.99,
  "projects_score": 85.9,
  "study_hours_per_week": 6.2,
  "stress_level": 5,
  "sleep_hours_per_night": 4.7
}   
```

# Response:

```json
{
  "predicted_final_score": 51.24135224298052
}
```

# Swagger UI for API Testing:
To interact with the API and test the predictions, visit the Swagger UI.

# How to Run the API Locally
# Prerequisites

* Python 3.7+

* virtualenv

* pip

# Steps:

1. Clone the Repository:
```bash
git clone https://github.com/your-username/student-performance-prediction.git
cd student-performance-prediction
```

2. Create a Virtual Environment:

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows, use venv\Scripts\activate
```

3. Install Dependencies:

```bash
pip install -r requirements.txt
```
4. Run the Application:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

5. Access the API:

* Open [this link](https://linear-regression-model-1-ocmt.onrender.com/docs) to access the Swagger UI and test the API.


# YouTube Demo
Here is a 2-minute demo showing how the API works and how to use it:
[Watch the Demo](https://www.youtube.com/watch?v=9WM-k11zHiw)

# How to Run the Mobile App
# Prerequisites:

## Running and Debugging the FastAPI Application in VSCode

This guide will walk you through the steps to run and debug your FastAPI application directly within VSCode.

**Prerequisites:**

* VSCode installed.
* Python installed.
* Virtual environment (`venv`) created (if not, create one using `python -m venv venv`).
* Dependencies listed in `requirements.txt`.

**Steps:**

1.  **Open the project in VSCode:**
    * Open VSCode.
    * Go to `File > Open Folder...` and select your project directory.

2.  **Open the integrated terminal:**
    * In VSCode, go to `View > Terminal` (or press `Ctrl + ~` or `Cmd + ~` on macOS).

3.  **Navigate to the project directory (if needed):**
    * Use the `cd` command to navigate to the root of your project if you're not already there.

4.  **Activate the virtual environment:**
    * **Windows:**
        ```bash
        .\venv\Scripts\activate
        ```
    * **macOS/Linux:**
        ```bash
        source venv/bin/activate
        ```

5.  **Install the dependencies:**
    * Once the virtual environment is activated, install the dependencies by running:
        ```bash
        pip install -r requirements.txt
        ```

6.  **Start the FastAPI application:**
    * You can now run your FastAPI app directly from the VSCode terminal.
    * Make sure your virtual environment is activated (you should see `(venv)` in your terminal prompt).
    * Run the application using uvicorn:
        ```bash
        uvicorn main:app --reload
        ```
        * The `--reload` flag will auto-reload the server whenever you make changes to the code.
    * This should start the FastAPI server, and you should see output like:
        ```text
        INFO:     Uvicorn running on [http://127.0.0.1:8000](http://127.0.0.1:8000) (Press CTRL+C to quit)
        ```

7.  **Access the application:**
    * Open your browser and go to `http://127.0.0.1:8000` to check the FastAPI app.
    * To access the Swagger UI for testing API endpoints, go to:
        ```text
        [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
        ```

**Debugging with VSCode:**

1.  **Set up debugging:**
    * In the Run and Debug view of VSCode (the bug icon on the left sidebar), click on "create a launch.json file".
    * Select "Python" and then choose "FastAPI" from the list of configurations (or choose a "Python" configuration and adjust the settings).

2.  **Add breakpoints:**
    * You can add breakpoints in your Python code by clicking next to the line numbers in the editor. This will pause execution at those points during debugging.

3.  **Start debugging:**
    * Press the green play button in the Run and Debug view to start debugging the application.

By following these steps, you'll be able to run and debug your FastAPI application directly within VSCode.


# License
This project is licensed under the MIT License - see the LICENSE file for details.
