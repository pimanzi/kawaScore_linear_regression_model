from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, confloat, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

# Load the trained model
MODEL_PATH = "../linear_regression/best_model.joblib"
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


app = FastAPI(
    title="KawaScore Coffee Quality Prediction API",
    description="An API to predict the Total Cup Points of coffee samples based on sensory attributes.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root():
    """
    Root endpoint that provides a welcome message and instructions.
    """
    return {
        "message": "Welcome to the KawaScore Coffee Quality Prediction API!",
        "instructions": {
            "description": "Use the `/predict` endpoint to predict the Total Cup Points of coffee samples.",
            "endpoint": "/predict",
            "example_request": {
                "aroma": 7.5,
                "acidity": 8.0,
                "body": 7.0,
                "uniformity": 9.0,
                "clean_cup": 10.0,
                "sweetness": 8.5,
            },
            "example_response": {
                "predicted_total_cup_points": 85.3
            },
            "documentation": "Visit /docs for interactive API documentation.",
        },
    }


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
        raise HTTPException(
            status_code=400,
            detail={
                "message": "An error occurred while processing your request.",
                "error": str(exc),
            },
        ) from exc


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)