import unittest
from unittest.mock import MagicMock
from hypothesis import given, strategies as st
from declusor.core.session import Session

class TestSessionFuzz(unittest.TestCase):
    
    @given(st.binary())
    def test_read_fuzz(self, data):
        """
        Fuzz the read method with random binary data.
        It should yield chunks or raise ConnectionResetError/ConnectionError, but not crash with other errors.
        """
        mock_socket = MagicMock()
        
        # Setup the mock to return chunks of the data
        # We split the data into small chunks to simulate network packets
        chunk_size = 16
        chunks = [data[i:i+chunk_size] for i in range(0, len(data), chunk_size)]
        
        # Custom side effect to yield chunks and then b"" forever
        def side_effect():
            for chunk in chunks:
                yield chunk
            while True:
                yield b""
        
        mock_socket.recv.side_effect = side_effect()
        
        server_ack = b"<ACK>"
        client_ack = b"<CLT>"
        
        # We need to mock load_library to avoid init failure
        with unittest.mock.patch("declusor.core.session.load_library", return_value=b""):
            session = Session(mock_socket, server_ack, client_ack)
            
            try:
                # Consume the generator
                for _ in session.read():
                    pass
            except ConnectionResetError:
                # Expected if EOF reached without ACK or during read
                pass
            except Exception as e:
                self.fail(f"Session.read crashed with {type(e).__name__}: {e} on input {data!r}")

