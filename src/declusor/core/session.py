import socket
from typing import Generator

from declusor import config, interface, util


class SocketSession(interface.ISession):
    """Manages a session over a socket connection, handling reading and writing of data."""

    __DEFAULT_SERVER_ACK = config.Settings.ACK_SERVER_VALUE
    _DEFAULT_CLIENT_ACK = util.hash_client_acknowledge(config.Settings.ACK_CLIENT_VALUE)
    _DEFAULT_BUFFER_SIZE = 2**8
    _DEFAULT_TIMEOUT = 1.0

    def __init__(
        self,
        conn: socket.socket,
        /,
        *,
        client_ack: bytes = _DEFAULT_CLIENT_ACK,
        timeout: float | None = _DEFAULT_TIMEOUT,
        bufsize: int = _DEFAULT_BUFFER_SIZE,
    ) -> None:
        """
        Initialize the Session.

        Args:
            socket: The socket connection.
            timeout: Socket timeout in seconds.
            bufsize: Buffer size for reading data in bytes.
        """

        self._socket = conn
        self._client_ack = client_ack
        self._timeout = timeout
        self._bufsize = bufsize

        self._socket.settimeout(self._timeout)

    def initialize(self, library: bytes) -> None:
        """Perform initial handshake/setup."""

        self.write(library)

        try:
            initial_data = self._socket.recv(self._bufsize)

            if initial_data != self._client_ack:
                raise config.SessionError("invalid client ACK during session initialization.")
        except TimeoutError as exc:
            raise config.SessionError("timeout waiting for client ACK during session initialization.") from exc

    @property
    def timeout(self) -> float | None:
        """Timeout for socket operations."""

        return self._timeout

    @timeout.setter
    def timeout(self, value: float | None, /) -> None:
        """Set the timeout for socket operations."""

        self._timeout = value
        self._socket.settimeout(self._timeout)

    def read(self) -> Generator[bytes, None, None]:
        """Read data from the connection until the client ACK is received.

        Yields chunks of data as they arrive, excluding the ACK. Only keeps a small
        buffer (size of ACK) to detect when transmission is complete.
        """

        ack, ack_len = self._client_ack, len(self._client_ack)
        buffer = bytearray()

        while True:
            try:
                chunk = self._socket.recv(self._bufsize)

                if not chunk:
                    raise ConnectionResetError("Connection closed by peer")

                combined = buffer + chunk
                ack_index = combined.find(ack)

                if ack_index != -1:
                    if ack_index > 0:
                        yield bytes(combined[:ack_index])

                    break

                if len(combined) >= ack_len:
                    yield_len = len(combined) - (ack_len - 1)

                    yield bytes(combined[:yield_len])

                    buffer = combined[yield_len:]
                else:
                    buffer = combined

            except TimeoutError as exc:
                raise config.SessionError("Timeout while reading from connection") from exc
            except OSError as exc:
                raise config.SessionError(f"Failed to read from connection: {exc}") from exc

    def write(self, content: bytes, /) -> None:
        """Write data to the connection followed by the client ACK.

        Args:
            content: The bytes to send.
        """

        try:
            self._socket.send(content)
            self._socket.send(self.__DEFAULT_SERVER_ACK)
        except TimeoutError as exc:
            raise config.SessionError("Timeout while writing to connection") from exc
        except OSError as exc:
            raise config.SessionError(f"Failed to write to connection: {exc}") from exc

    def close(self) -> None:
        """Close the session socket."""

        self._socket.close()
