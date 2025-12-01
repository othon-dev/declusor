import unittest
from unittest.mock import MagicMock, patch

from declusor.controller.command import call_command


class TestCommandController(unittest.TestCase):
    def setUp(self) -> None:
        self.mock_session = MagicMock()
        self.mock_router = MagicMock()

    @patch("declusor.controller.command.write_binary_message")
    @patch("declusor.controller.command.parse_command_arguments")
    def test_command_execution(self, mock_parse: MagicMock, mock_write_bin: MagicMock) -> None:
        # Setup mocks
        mock_parse.return_value = ({"command": "ls -la"}, [])
        self.mock_session.read.return_value = [b"output line 1\n", b"output line 2\n"]

        # Execute
        call_command(self.mock_session, self.mock_router, "ls -la")

        # Verify
        mock_parse.assert_called_with("ls -la", {"command": str})

        self.mock_session.write.assert_called_with(b"ls -la")
        self.assertEqual(mock_write_bin.call_count, 2)

        mock_write_bin.assert_any_call(b"output line 1\n")
        mock_write_bin.assert_any_call(b"output line 2\n")


if __name__ == "__main__":
    unittest.main()
