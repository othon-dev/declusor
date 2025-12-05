from enum import StrEnum
from typing import TypedDict


class DeclusorOptions(TypedDict):
    """Arguments for the application."""

    host: str
    port: int
    client: str


class FileFunc(StrEnum):
    """Enumeration of file operation functions."""

    EXEC_FILE = "execute_base64_encoded_value"
    STORE_FILE = "store_base64_encoded_value"


class Language(StrEnum):
    """Enumeration of supported scripting languages."""

    BASH = "bash"
    SH = "sh"
