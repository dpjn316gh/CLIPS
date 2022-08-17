from abc import ABC, abstractmethod

from app.ports.rules_engine.rules_engine import RulesEngine
from app.usecase.credit_card_payment.credit_card_payment_command_model import CreditCardPaymentRequestModel
from app.usecase.credit_card_payment.credit_card_payment_query_model import CreditCardPaymentModelResponseModel


class CreditCardPaymentCommandUseCase(ABC):

    @abstractmethod
    def load_rules(self, path: str):
        raise NotImplementedError

    @abstractmethod
    def ask_for_advice(self, data: CreditCardPaymentRequestModel) -> CreditCardPaymentModelResponseModel:
        raise NotImplementedError


class CreditCardPaymentCommandUseCaseImpl(CreditCardPaymentCommandUseCase):

    def __init__(self, rules_engine: RulesEngine):
        self.rules_engine = rules_engine

    def load_rules(self, path: str):
        self.rules_engine.load_rules(path)

    def ask_for_advice(self, data: CreditCardPaymentRequestModel) -> CreditCardPaymentModelResponseModel:
        return self.rules_engine.ask_for_advice_for_credit_card_payment(data)
