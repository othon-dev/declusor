from abc import ABC, abstractmethod
from typing import Generator


class ISession(ABC):
    """Session interface."""

    @abstractmethod
    def set_blocking(self, flag: bool) -> None:
        """Set the session to blocking mode."""

        raise NotImplementedError

    @abstractmethod
    def set_timeout(self, value: float) -> None:
        """Set the session timeout."""

        raise NotImplementedError

    @abstractmethod
    def read(self) -> Generator[bytes, None, None]:
        """Read data from the session."""

        raise NotImplementedError

    @abstractmethod
    def write(self, content: bytes) -> None:
        """Write data to the session."""

        raise NotImplementedError
