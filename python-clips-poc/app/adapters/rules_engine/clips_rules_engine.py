import clips
from clips import Environment

from app.ports.rules_engine.rules_engine import RulesEngine
from app.usecase.credit_card_payment.credit_card_payment_command_model import CreditCardPaymentRequestModel
from app.usecase.credit_card_payment.credit_card_payment_query_model import CreditCardPaymentModelResponseModel


class RulesEngineImpl(RulesEngine):

    def __init__(self, clips_environment: Environment):
        self.clips_environment = clips_environment

    def load_rules(self, path: str):
        self.clips_environment.clear()
        self.clips_environment.batch_star(path)

    def ask_for_advice_for_credit_card_payment(self,
                                               data: CreditCardPaymentRequestModel) -> CreditCardPaymentModelResponseModel:
        template = self.clips_environment.find_template("credit-card-payment")

        current_fact = template.assert_fact(action_type=data.action_type,
                                            transaction_id=data.transaction_id,
                                            email=data.email,
                                            user_fullname=data.user_fullname,
                                            user_name=data.user_name,
                                            payment_method=clips.Symbol(data.payment_method),
                                            card_fullname=data.card_fullname,
                                            card_bin=data.card_bin,
                                            card_expire=data.card_expire,
                                            cvv_result=data.cvv_result,
                                            bank=clips.Symbol(data.bank),
                                            phone_number=data.phone_number,
                                            transaction_amount=data.transaction_amount,
                                            items_names=data.items_names,
                                            items_prices=data.items_prices,
                                            items_quantities=[int(item) for item in data.items_quantities],
                                            items_categories=data.items_categories,
                                            items_skus=data.items_skus,
                                            )

        possible_activations = []
        facts = [F"f-{current_fact.index}: current fact"]
        given_facts_indexes = set()
        for a in self.clips_environment.activations():
            fact_indexes = str(a).split(":")
            for fact_index in fact_indexes[1].replace("f-", "").strip().split(","):
                given_facts_indexes.add(int(fact_index))
            possible_activations.append(str(a))

        self.clips_environment.run()

        for fact in self.clips_environment.facts():
            if fact.template.name == "credit-card-payment-response" and fact['transaction_id'] == data.transaction_id:
                action = fact['action']
                activation_rule = fact['activation_rule']
                fact.retract()
                break

        for fact in [f for f in self.clips_environment.facts() if f.index in given_facts_indexes]:
            facts.append(f"f-{fact.index}: {str(fact)}")

        return CreditCardPaymentModelResponseModel(transaction_id=data.transaction_id, activation_rule=activation_rule,
                                                   action=action, possible_activations=possible_activations,
                                                   facts=facts)
