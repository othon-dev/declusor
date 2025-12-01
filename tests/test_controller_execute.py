import unittest
from unittest.mock import patch, MagicMock
import sys
import os

from declusor.controller.execute import call_execute
from declusor.config import InvalidArgument


class TestExecuteController(unittest.TestCase):
    def setUp(self):
        self.mock_session = MagicMock()
        self.mock_router = MagicMock()

    @patch("declusor.controller.execute.write_error_message")
    @patch("declusor.controller.execute.write_binary_message")
    @patch("declusor.controller.execute.format_bash_function_call")
    @patch("declusor.controller.execute.load_file")
    @patch("declusor.controller.execute.parse_command_arguments")
    def test_execute_success(self, mock_parse, mock_load, mock_format, mock_write_bin, mock_error):
        # Setup
        mock_parse.return_value = ({"filepath": "script.sh"}, ["arg1", "arg2"])
        mock_load.return_value = b"script_content"
        mock_format.return_value = "bash_command"
        self.mock_session.read.return_value = [b"output"]

        # Execute
        call_execute(self.mock_session, self.mock_router, "script.sh arg1 arg2")

        # Verify
        mock_load.assert_called_with("script.sh")
        # b64encode(b"script_content").decode() is 'c2NyaXB0X2NvbnRlbnQ='
        mock_format.assert_called_with("execute_base64_encoded_value", "c2NyaXB0X2NvbnRlbnQ=", "arg1", "arg2")
        self.mock_session.write.assert_called_with(b"bash_command")
        mock_write_bin.assert_called_with(b"output")
        mock_error.assert_not_called()

    @patch("declusor.controller.execute.write_error_message")
    @patch("declusor.controller.execute.load_file")
    @patch("declusor.controller.execute.parse_command_arguments")
    def test_execute_invalid_argument(self, mock_parse, mock_load, mock_error):
        # Setup
        mock_parse.return_value = ({"filepath": "missing.sh"}, [])
        mock_load.side_effect = InvalidArgument("file not found")

        # Execute
        call_execute(self.mock_session, self.mock_router, "missing.sh")

        # Verify
        mock_error.assert_called_with("invalid argument: file not found")
        self.mock_session.write.assert_not_called()


if __name__ == "__main__":
    unittest.main()
