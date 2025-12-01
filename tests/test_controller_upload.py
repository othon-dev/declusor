import unittest
from unittest.mock import patch, MagicMock
import sys
import os

from declusor.controller.upload import call_upload
from declusor.config import InvalidArgument


class TestUploadController(unittest.TestCase):
    def setUp(self):
        self.mock_session = MagicMock()
        self.mock_router = MagicMock()

    @patch("declusor.controller.upload.write_error_message")
    @patch("declusor.controller.upload.write_binary_message")
    @patch("declusor.controller.upload.format_bash_function_call")
    @patch("declusor.controller.upload.load_file")
    @patch("declusor.controller.upload.parse_command_arguments")
    def test_upload_success(self, mock_parse, mock_load, mock_format, mock_write_bin, mock_error):
        # Setup
        mock_parse.return_value = ({"filepath": "local_file.txt"}, [])
        mock_load.return_value = b"file_content"
        mock_format.return_value = "bash_command"
        self.mock_session.read.return_value = [b"response"]

        # Execute
        call_upload(self.mock_session, self.mock_router, "local_file.txt")

        # Verify
        mock_load.assert_called_with("local_file.txt")
        # b64encode(b"file_content").decode() is 'ZmlsZV9jb250ZW50'
        mock_format.assert_called_with("store_base64_encoded_value", "ZmlsZV9jb250ZW50")
        self.mock_session.write.assert_called_with(b"bash_command")
        mock_write_bin.assert_called_with(b"response")
        mock_error.assert_not_called()

    @patch("declusor.controller.upload.write_error_message")
    @patch("declusor.controller.upload.load_file")
    @patch("declusor.controller.upload.parse_command_arguments")
    def test_upload_invalid_argument(self, mock_parse, mock_load, mock_error):
        # Setup
        mock_parse.return_value = ({"filepath": "missing.txt"}, [])
        mock_load.side_effect = InvalidArgument("file not found")

        # Execute
        call_upload(self.mock_session, self.mock_router, "missing.txt")

        # Verify
        mock_error.assert_called_with("invalid argument: file not found")
        self.mock_session.write.assert_not_called()


if __name__ == "__main__":
    unittest.main()
