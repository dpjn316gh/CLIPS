from typing import List

from pydantic import BaseModel


class CreditCardPaymentModelResponseModel(BaseModel):
    transaction_id: str
    activation_rule: str
    possible_activations: List[str] = []
    facts: List[str] = []
    action: str
