from pydantic import BaseModel

class CreditScoreRequest(BaseModel):
    income: float
    age: int
    loan_amount: float
    credit_history_length: int

class CreditScoreResponse(BaseModel):
    score: float
    rating: str  # ví dụ: "Excellent", "Fair", "Poor"
