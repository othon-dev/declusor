class DeclusorException(Exception):
class DeclusorWarning(Warning):
    """Base warning for Declusor-related warnings.
    
    Used to signal non-critical issues that don't prevent operation but should be brought to the user's attention.
    """

    def __init__(self, /, description: str) -> None:
        """Initialize the warning.
        
        Args:
            description: Human-readable description of the warning.
        """
        self.description = description

        super().__init__(self.description)


class InvalidOperation(DeclusorException):
    """An internal operation cannot be performed for any reason."""

    def __init__(self, /, description: str) -> None:
        self.description = description

        super().__init__(f"invalid operation: {self.description}")


class ParserError(DeclusorException):
    """Error parsing command-line arguments."""


class RouterError(DeclusorException):
    """Route cannot be processed for any reason."""

    def __init__(self, /, route: str, *, description: str | None = None) -> None:
        self.route = route
        self.description = description

        super().__init__(f"invalid route: {self.route!r}")


class PromptError(DeclusorException):
    """User supplied argument cannot be processed for any reason."""

    def __init__(self, /, argument: str, *, description: str | None = None) -> None:
        self.argument = argument
        self.description = description

        super().__init__(f"invalid argument: {self.argument!r}")


class ControllerError(DeclusorException):
    """An error occurred in the controller."""

    def __init__(self, /, description: str) -> None:
        self.description = description

        super().__init__(f"controller error: {self.description}")


class ExitRequest(DeclusorException):
    """Request to exit the application."""
