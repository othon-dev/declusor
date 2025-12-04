from abc import ABC, abstractmethod
from typing import TypedDict


class DeclusorArguments(TypedDict):
    """Arguments for the application."""

    host: str
    port: int
    client: str


class IParser(ABC):
    """Argument parser interface."""

    @abstractmethod
    async def parse(self) -> DeclusorArguments:
        """Parse command-line arguments."""

        raise NotImplementedError
