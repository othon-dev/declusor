import sys
from abc import ABC, abstractmethod
from pathlib import Path
from typing import Sequence


class IConsole(ABC):
    """Abstract base class defining the console interface for input reading."""

    @abstractmethod
    def setup_completer(self, commands: Sequence[str], /) -> None:
        """Set up the readline completer for command line input.

        Args:
            commands: Sequence of available commands.
        """

        raise NotImplementedError

    @abstractmethod
    def enable_history(self, history_file: Path, /) -> None:
        """Enable history saving and loading.

        Args:
            history_file: Path to the history file.
        """

        raise NotImplementedError

    def read_line(self, prompt: str = "", /) -> str:
        """Read a line from standard input with readline support.

        Args:
            prompt: The prompt to display to the user.

        Returns:
            The input string.

        Note:
            Uses input() to preserve readline functionality (autocomplete, history).
            This is a blocking call.
        """

        return input(prompt)

    def read_stripped_line(self, prompt: str = "", /) -> str:
        """Read a line from standard input and strip whitespace.

        Args:
            prompt: The prompt to display to the user.

        Returns:
            The stripped input string.
        """

        return self.read_line(prompt).strip()

    def write_message(self, message: str, /) -> None:
        """
        Write a message to standard output.

        Args:
            message: The message string to write.
        """

        sys.stdout.write(message + "\n")
        sys.stdout.flush()

    def write_binary_data(self, message: bytes, /) -> None:
        """
        Write a binary message to standard output.

        Args:
            message: The binary data to write.
        """

        sys.stdout.buffer.write(message)
        sys.stdout.buffer.flush()

    def write_error_message(self, message: str | BaseException, /) -> None:
        """
        Write an error message to standard error.

        Args:
            message: The error message or exception to write.
        """

        sys.stderr.write(f"error: {message}\n")
        sys.stderr.flush()

    def write_warning_message(self, message: str | BaseException, /) -> None:
        """
        Write a warning message to standard error.

        Args:
            message: The warning message or exception to write.
        """

        sys.stderr.write(f"warning: {message}\n")
        sys.stderr.flush()
