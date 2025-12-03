import sys


def read_stripped_message(prompt: str = "") -> str:
    """Read a message from standard input and strip whitespace."""

    return input(prompt).strip()


def write_string_message(message: str) -> None:
    """Write a message to standard output."""

    sys.stdout.write(message + "\n")
    sys.stdout.flush()


def write_binary_data(message: bytes) -> None:
    """Write a binary message to standard output."""

    sys.stdout.buffer.write(message)
    sys.stdout.buffer.flush()


def write_error_message(message: str | BaseException) -> None:
    """Write an error message to standard error."""

    sys.stderr.write(f"error: {message}\n")
    sys.stderr.flush()


def write_warning_message(message: str | BaseException) -> None:
    """Write a warning message to standard error."""

    sys.stderr.write(f"warning: {message}\n")
    sys.stderr.flush()
