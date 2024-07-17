import sys


def write_message(message: str) -> None:
    sys.stdout.write(message + "\n")
    sys.stdout.buffer.flush()


def write_binary_message(message: bytes) -> None:
    sys.stdout.buffer.write(message)
    sys.stdout.buffer.flush()


def write_error_message(message: str) -> None:
    sys.stderr.write(f"error: {message}\n".lower())
    sys.stderr.flush()


def write_warninig_message(message: str) -> None:
    sys.stderr.write(f"warning: {message}\n".lower())
    sys.stderr.flush()
