from pydantic import BaseModel, Field

from app.domain.clips.clips_exceptions import TemplateNotFoundError


class ErrorMessageTemplateNotFound(BaseModel):
    detail: str = Field(example=TemplateNotFoundError.message)
