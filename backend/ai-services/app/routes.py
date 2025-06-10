from fastapi import APIRouter

from app.ml_models import predict_credit_score, score_to_rating
from app.schemas import CreditScoreResponse, CreditScoreRequest

router = APIRouter()

@router.get("/")
def read_root():
    return {"message": "Hello from ai-services FastAPI!"}

@router.post("/predict/credit-score", response_model=CreditScoreResponse)
def predict_credit_score_endpoint(req: CreditScoreRequest):
    score = predict_credit_score(
        income=req.income,
        age=req.age,
        loan_amount=req.loan_amount,
        credit_history_length=req.credit_history_length
    )
    rating = score_to_rating(score)
    return CreditScoreResponse(score=round(score, 2), rating=rating)