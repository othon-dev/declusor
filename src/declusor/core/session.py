import socket
from typing import Generator

from interface import ISession
from util import load_library, write_warning_message


class Session(ISession):
    """
    Manages a session over a socket connection, handling reading and writing
    of data with specific acknowledgement (ACK) protocols.
    """

    DEFAULT_BUFSIZE = 4096
    DEFAULT_TIMEOUT = 0.75

    def __init__(
        self,
        connection: socket.socket,
        server_ack: bytes,
        client_ack: bytes,
        timeout: float = DEFAULT_TIMEOUT,
    ) -> None:
        """
        Initialize the Session.

        Args:
            connection: The active socket connection.
            server_ack: The byte sequence expected from the server to signal end of message.
            client_ack: The byte sequence sent to the client after writing data.
            timeout: Socket timeout in seconds.
        """
        self.connection = connection
        self.server_ack = server_ack
        self.client_ack = client_ack
        self._timeout = timeout

        # Configure initial socket state
        self.set_timeout(self._timeout)

        # Initial handshake/setup
        try:
            self.write(load_library())
            # Check for immediate response indicating failure
            self.connection.settimeout(0.1)  # Short timeout for check
            try:
                initial_data = self.connection.recv(self.DEFAULT_BUFSIZE)
                if initial_data:
                    write_warning_message("the library import may have failed.")
            except socket.timeout:
                pass  # No data means likely success in this context
            finally:
                self.set_timeout(self._timeout)
        except Exception:
             # Log or handle initialization errors if necessary
             pass

    def set_blocking(self, flag: bool) -> None:
        """Set the blocking mode of the socket."""
        self.connection.setblocking(flag)

    def set_timeout(self, value: float) -> None:
        """Set the timeout for socket operations."""
        self._timeout = value
        self.connection.settimeout(value)

    def read(self) -> Generator[bytes, None, None]:
        """
        Read data from the connection until the server ACK is received.
        Yields chunks of data as they arrive, excluding the ACK.
        """
        buffer = bytearray()
        ack_len = len(self.server_ack)

        while True:
            try:
                chunk = self.connection.recv(self.DEFAULT_BUFSIZE)
                if not chunk:
                    raise ConnectionResetError("Connection closed by peer")
                
                buffer.extend(chunk)

                # Check if ACK is present in the buffer
                # We only need to check the end of the buffer, covering the size of the chunk + ACK length overlap
                search_start = max(0, len(buffer) - len(chunk) - ack_len)
                ack_index = buffer.find(self.server_ack, search_start)

                if ack_index != -1:
                    # ACK found. Yield data up to ACK and stop.
                    yield bytes(buffer[:ack_index])
                    break
                
                # If buffer is larger than ACK length, we can safely yield the beginning
                if len(buffer) > ack_len:
                    safe_len = len(buffer) - ack_len
                    yield bytes(buffer[:safe_len])
                    del buffer[:safe_len]
                
            except socket.timeout:
                continue

    def write(self, content: bytes) -> None:
        """
        Write data to the connection followed by the client ACK.
        
        Args:
            content: The bytes to send.
        """
        try:
            # Send all data in one go if possible to reduce syscalls
            payload = content + self.client_ack
            self.connection.sendall(payload)
        except OSError as e:
            raise ConnectionError(f"Failed to write to connection: {e}") from e
