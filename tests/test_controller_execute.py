import unittest
from unittest.mock import MagicMock, patch


from declusor.controller.execute import call_execute


class TestExecuteController(unittest.TestCase):
    def setUp(self) -> None:
        self.mock_session = MagicMock()
        self.mock_router = MagicMock()

    @patch("declusor.controller.execute.write_binary_message")
    @patch("declusor.controller.execute.format_bash_function_call")
    @patch("declusor.controller.execute.safe_load_file")
    @patch("declusor.controller.execute.parse_command_arguments")
    def test_execute_success(
        self,
        mock_parse: MagicMock,
        mock_load: MagicMock,
        mock_format: MagicMock,
        mock_write_bin: MagicMock,
    ) -> None:
        # Setup
        mock_parse.return_value = ({"filepath": "script.sh"}, ["arg1", "arg2"])
        mock_load.return_value = b"script_content"
        mock_format.return_value = "bash_command"

        self.mock_session.read.return_value = [b"output"]

        # Execute
        call_execute(self.mock_session, self.mock_router, "script.sh arg1 arg2")

        # Verify
        mock_load.assert_called_with("script.sh")
        mock_format.assert_called_with("execute_base64_encoded_value", "c2NyaXB0X2NvbnRlbnQ=", "arg1", "arg2")

        self.mock_session.write.assert_called_with(b"bash_command")

        mock_write_bin.assert_called_with(b"output")

    @patch("declusor.controller.execute.safe_load_file")
    @patch("declusor.controller.execute.parse_command_arguments")
    def test_execute_invalid_argument(self, mock_parse: MagicMock, mock_load: MagicMock) -> None:
        # Setup
        mock_parse.return_value = ({"filepath": "missing.sh"}, [])
        mock_load.return_value = None

        # Execute
        call_execute(self.mock_session, self.mock_router, "missing.sh")

        # Verify
        mock_load.assert_called_with("missing.sh")
        self.mock_session.write.assert_not_called()


if __name__ == "__main__":
    unittest.main()
