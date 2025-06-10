def predict_credit_score(income: float, age: int, loan_amount: float, credit_history_length: int) -> float:
    # Dummy ML logic
    base_score = 300
    score = base_score + (income * 0.02) - (loan_amount * 0.05) + (credit_history_length * 5) + (age * 0.1)
    return max(300, min(score, 850))  # credit score range: 300–850

def score_to_rating(score: float) -> str:
    if score >= 750:
        return "Excellent"
    elif score >= 650:
        return "Good"
    elif score >= 550:
        return "Fair"
    else:
        return "Poor"
