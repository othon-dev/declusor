from argparse import ArgumentParser, HelpFormatter
from typing import NoReturn

from declusor import config, interface


class DeclusorParser(ArgumentParser):
    """Parser for command-line arguments."""

    info = {
        "host": "IP address or hostname where the service should run",
        "port": "port number to listen on for incoming connections",
        "client": "agent responsible for handling requests",
        # "listen": "start the service to listen for incoming connections",
    }

    def __init__(self, prog: str, description: str, version: str) -> None:
        super().__init__(prog=prog, description=description, formatter_class=self._create_formatter)

        self._version = version

    def parse(self) -> interface.DeclusorArguments:
        """Parse command-line arguments."""

        self.add_argument("host", help=self.info["host"], type=str)
        self.add_argument("port", help=self.info["port"], type=int)
        self.add_argument("-c", "--client", help=self.info["client"], type=str, default=config.DEFAULT_CLIENT)

        args = self.parse_args()

        try:
            return interface.DeclusorArguments(host=args.host, port=args.port, client=args.client)
        except AttributeError as e:
            raise config.ArgumentParsingError(f"Missing argument: {e.name}") from e

    def error(self, message: str) -> NoReturn:
        """Overrides the default ArgumentParser error behavior."""

        raise config.ArgumentParsingError(message)

    @staticmethod
    def _create_formatter(*, prog: str) -> HelpFormatter:
        return HelpFormatter(prog, max_help_position=30)
