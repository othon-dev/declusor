import socket
import unittest
from unittest.mock import MagicMock, patch

from declusor.core.session import Session


class TestSession(unittest.TestCase):
    def setUp(self) -> None:
        self.mock_socket = MagicMock(spec=socket.socket)
        self.server_ack = b"<ACK>"
        self.client_ack = b"<CLT>"

        # Mock load_library to prevent file I/O during init
        with patch("declusor.core.session.load_library", return_value=b"init_data"):
            self.session = Session(self.mock_socket, self.server_ack, self.client_ack)

    def test_init_sends_library(self) -> None:
        """Test that initialization sends the library data."""
        # This is handled in setUp, but we verify the calls
        self.mock_socket.sendall.assert_called()

    def test_write_sends_content_and_ack(self) -> None:
        """Test that write sends content followed by client ACK."""
        content = b"hello"
        self.session.write(content)

        expected_payload = content + self.client_ack
        self.mock_socket.sendall.assert_called_with(expected_payload)

    def test_read_yields_data_until_ack(self) -> None:
        """Test reading data that arrives in chunks, ending with ACK."""
        # Setup mock to return chunks
        # Chunk 1: "Hello "
        # Chunk 2: "World" + ACK
        self.mock_socket.recv.side_effect = [b"Hello ", b"World" + self.server_ack, b""]  # EOF

        received_chunks = list(self.session.read())
        full_data = b"".join(received_chunks)

        self.assertEqual(full_data, b"Hello World")

    def test_read_handles_split_ack(self) -> None:
        """Test reading when the ACK is split across chunks."""
        # ACK is <ACK> (5 bytes)
        # Chunk 1: "Data" + "<AC"
        # Chunk 2: "K>"
        self.mock_socket.recv.side_effect = [b"Data<AC", b"K>", b""]

        received_chunks = list(self.session.read())
        full_data = b"".join(received_chunks)

        self.assertEqual(full_data, b"Data")

    def test_read_connection_closed(self) -> None:
        """Test that ConnectionResetError is raised if peer closes connection."""
        self.mock_socket.recv.return_value = b""

        with self.assertRaises(ConnectionResetError):
            next(self.session.read())


if __name__ == "__main__":
    unittest.main()
