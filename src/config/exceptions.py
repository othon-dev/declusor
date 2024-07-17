class LocalException(Exception):
    """Base exception."""

    pass


class ArgumentParsingError(LocalException):
    """An error occurred during argument parsing."""

    pass


class InvalidRoute(LocalException):
    """Route doesn't exist or can't be processed."""

    def __init__(self, route: str) -> None:
        super().__init__(f"invalid route: {route}")


class InvalidArgument(LocalException):
    """Argument value cannot be processed for any reason."""

    def __init__(self, route: str) -> None:
        super().__init__(f"invalid argument: {route}")
