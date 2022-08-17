class TemplateNotFoundError(Exception):
    message = "La plantilla no existe."

    def __str__(self):
        return TemplateNotFoundError.message
