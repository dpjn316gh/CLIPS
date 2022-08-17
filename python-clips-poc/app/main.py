import datetime
import logging
from logging import config

import uvicorn as uvicorn
from clips import Environment
from fastapi import FastAPI, Depends, HTTPException
from mangum import Mangum
from starlette import status

from app.adapters.api.api_errors import ErrorMessageTemplateNotFound
from app.adapters.rules_engine.clips_client import localhost_clips_knowledge_base_path, \
    aws_clips_knowledge_base_path, get_clips_for_localhost, get_clips_for_aws
from app.adapters.rules_engine.clips_rules_engine import RulesEngineImpl
from app.domain.clips.clips_exceptions import TemplateNotFoundError
from app.usecase.credit_card_payment.credit_card_payment_command_model import CreditCardPaymentRequestModel
from app.usecase.credit_card_payment.credit_card_payment_command_usecase import CreditCardPaymentCommandUseCase, \
    CreditCardPaymentCommandUseCaseImpl
from app.usecase.credit_card_payment.credit_card_payment_query_model import CreditCardPaymentModelResponseModel

config.fileConfig("app/logging.conf", disable_existing_loggers=False)
logger = logging.getLogger(__name__)

app = FastAPI(title="AntiFraud Expert System",
              description="CLIPS AntiFraud Expert System",
              version="0.0.1", )

########################################################################################################################
ENVIRONMENT = 'localhost'
########################################################################################################################

clips_knowledge_base_path = ''
clips_environment = None

if ENVIRONMENT == 'localhost':
    clips_knowledge_base_path = localhost_clips_knowledge_base_path
    clips_environment = get_clips_for_localhost()
if ENVIRONMENT == 'aws':
    clips_knowledge_base_path = aws_clips_knowledge_base_path
    clips_environment = get_clips_for_aws()


def get_clips_environment() -> Environment:
    yield clips_environment


def get_credit_card_payment_command_usecase() -> CreditCardPaymentCommandUseCase:
    rules_engine = RulesEngineImpl(clips_environment=clips_environment)
    return CreditCardPaymentCommandUseCaseImpl(rules_engine)


handler = Mangum(app)


@app.post(
    "/credit-card-payment",
    response_model=CreditCardPaymentModelResponseModel,
    status_code=status.HTTP_200_OK,
    responses={
        status.HTTP_406_NOT_ACCEPTABLE: {
            "model": ErrorMessageTemplateNotFound,
        },
    },
)
async def ask_for_advice_for_credit_card_payment(
        data: CreditCardPaymentRequestModel,
        credit_card_payment_command_usecase: CreditCardPaymentCommandUseCase = Depends(
            get_credit_card_payment_command_usecase)):
    try:
        logger.info("ask_for_advice_for_credit_card_payment")
        return credit_card_payment_command_usecase.ask_for_advice(data)
    except TemplateNotFoundError as e:
        logger.error(e)
        raise HTTPException(
            status_code=status.HTTP_428_PRECONDITION_REQUIRED,
            detail=e.message,
        )
    except Exception as e:
        logger.error(e)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )


@app.get("/load-rules")
async def load_rules(credit_card_payment_command_usecase: CreditCardPaymentCommandUseCase = Depends(
    get_credit_card_payment_command_usecase)):
    credit_card_payment_command_usecase.load_rules(clips_knowledge_base_path)
    return {"Bold AntiFraud Expert System": "Powered by CLIPS",
            "Knowledge base path": clips_knowledge_base_path,
            "Update date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}


@app.get("/")
def root():
    return {"Bold AntiFraud Expert System. It works!": "Powered by CLIPS"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
