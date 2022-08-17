from abc import ABC, abstractmethod

from app.usecase.credit_card_payment.credit_card_payment_command_model import CreditCardPaymentRequestModel
from app.usecase.credit_card_payment.credit_card_payment_query_model import CreditCardPaymentModelResponseModel


class RulesEngine(ABC):

    @abstractmethod
    def load_rules(self, path: str):
        raise NotImplementedError

    @abstractmethod
    def ask_for_advice_for_credit_card_payment(self, data: CreditCardPaymentRequestModel) -> CreditCardPaymentModelResponseModel:
        raise NotImplementedError
