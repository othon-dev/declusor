import unittest
from unittest.mock import patch, MagicMock
import sys
import os
from threading import Event

from declusor.controller.shell import call_shell, handle_input_data, handle_socket_data


class TestShellController(unittest.TestCase):
    def setUp(self):
        self.mock_session = MagicMock()
        self.mock_router = MagicMock()

    @patch("declusor.controller.shell.handle_input_data")
    @patch("declusor.controller.shell.handle_socket_data")
    @patch("declusor.controller.shell.Thread")
    @patch("declusor.controller.shell.parse_command_arguments")
    def test_call_shell_orchestration(self, mock_parse, mock_thread_cls, mock_handle_socket, mock_handle_input):
        # Setup
        mock_thread_instance = MagicMock()
        mock_thread_cls.return_value = mock_thread_instance

        # Execute
        call_shell(self.mock_session, self.mock_router, "")

        # Verify
        mock_parse.assert_called()
        mock_thread_cls.assert_called()
        mock_thread_instance.start.assert_called()
        mock_handle_input.assert_called_with(self.mock_session)
        mock_thread_instance.join.assert_called()

    @patch("declusor.controller.shell.read_message")
    def test_handle_input_data(self, mock_read):
        # Setup: read returns a command, then raises StopIteration (or we break loop manually)
        # Since handle_input_data is while True, we need to throw an exception to break it
        mock_read.side_effect = ["cmd1", KeyboardInterrupt]

        try:
            handle_input_data(self.mock_session)
        except KeyboardInterrupt:
            pass

        self.mock_session.write.assert_called_with(b"cmd1")

    @patch("declusor.controller.shell.write_binary_message")
    def test_handle_socket_data(self, mock_write):
        # Setup
        flag = Event()
        self.mock_session.read.return_value = [b"data1", b"data2"]

        # We need to set the flag eventually to stop the loop, but the loop checks flag.is_set()
        # The loop is: while not flag.is_set(): for data in session.read(): ...
        # If session.read() yields items, it processes them.
        # If session.read() finishes (yields nothing more), the inner loop finishes.
        # Then it checks flag.is_set() again.
        # We need to make sure the loop terminates.

        # Strategy: Run in a separate thread or just ensure session.read finishes and we set flag?
        # Actually, handle_socket_data loops forever until flag is set.
        # We can mock session.read to set the flag as a side effect?

        def side_effect_read():
            yield b"data1"
            flag.set()  # Stop the outer loop after this generator finishes

        self.mock_session.read.side_effect = side_effect_read

        handle_socket_data(self.mock_session, flag)

        mock_write.assert_any_call(b"data1")


if __name__ == "__main__":
    unittest.main()
