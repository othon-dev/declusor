from declusor import config, interface, util


class DeclusorParser(util.Parser, interface.IParser[config.DeclusorOptions]):
    """Parser for command-line arguments."""

    info = {
        "host": "IP address or hostname where the service should run",
        "port": "port number to listen on for incoming connections",
        "client": "agent responsible for handling requests",
    }

    def parse(self) -> config.DeclusorOptions:
        """Parse command-line arguments."""

        self.add_argument("host", help=self.info["host"], type=str)
        self.add_argument("port", help=self.info["port"], type=int)
        self.add_argument("-c", "--client", help=self.info["client"], type=str, default=config.Settings.DEFAULT_CLIENT)

        args = self.parse_args()

        try:
            return config.DeclusorOptions(host=args.host, port=args.port, client=args.client)
        except AttributeError as e:
            raise config.ParserError(f"Missing argument: {e.name}") from e
