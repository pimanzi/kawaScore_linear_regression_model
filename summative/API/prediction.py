"""
FastAPI app for predicting Total Cup Points for coffee samples.
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, confloat, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

# Load the trained model
MODEL_PATH = "../linear_regression/best_model.joblib."
try:
    MODEL = joblib.load(MODEL_PATH)
except FileNotFoundError as err:
    raise RuntimeError(f"Failed to load model from {MODEL_PATH}: {err}") from err


class CoffeeFeatures(BaseModel):
    """
    Pydantic model for coffee sample features.
    All values must be between 0 and 10.
    """
    aroma: confloat(ge=0, le=10)
    acidity: confloat(ge=0, le=10)
    body: confloat(ge=0, le=10)
    uniformity: confloat(ge=0, le=10)
    clean_cup: confloat(ge=0, le=10) = Field(alias="Clean Cup")
    sweetness: confloat(ge=0, le=10)


# Initialize FastAPI app
app = FastAPI()

# Enable CORS for all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)


@app.post("/predict")
def predict(coffee_features: CoffeeFeatures):
    """
    Predict the Total Cup Points for a coffee sample based on its features.

    Args:
        coffee_features (CoffeeFeatures): Input features for the coffee sample.

    Returns:
        dict: Predicted Total Cup Points.
    """
    try:
        input_data = np.array([
            [
                coffee_features.aroma,
                coffee_features.acidity,
                coffee_features.body,
                coffee_features.uniformity,
                coffee_features.clean_cup,
                coffee_features.sweetness,
            ]
        ])

        prediction = MODEL.predict(input_data)
        return {"predicted_total_cup_points": prediction[0]}

    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
