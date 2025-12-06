from abc import ABC, abstractmethod
from typing import Generator


class ISession(ABC):
    """Abstract base class defining the session interface.

    Sessions manage network connections with clients, handling data
    transmission and timeout configuration.
    """

    @property
    @abstractmethod
    def timeout(self) -> float | None:
        """Timeout for socket operations.

        Returns:
            Float value representing the timeout in seconds, or None if no timeout is set.
        """

        raise NotImplementedError

    @timeout.setter
    @abstractmethod
    def timeout(self, value: float | None, /) -> None:
        """Set the session timeout.

        Args:
            value: Timeout duration in seconds.
        """

        raise NotImplementedError

    @abstractmethod
    def read(self) -> Generator[bytes, None, None]:
        """Read data from the session.

        Returns:
            Generator yielding bytes received from the session.
        """

        raise NotImplementedError

    @abstractmethod
    def write(self, content: bytes, /) -> None:
        """Write data to the session.

        Args:
            content: Binary data to send to the session.
        """

        raise NotImplementedError

    @abstractmethod
    def close(self) -> None:
        """Close the session stream."""

        raise NotImplementedError
