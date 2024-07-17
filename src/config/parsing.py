from argparse import ArgumentParser, HelpFormatter, Namespace

from config.default import CLIENT

HELP = {
    "host": "the IP address or hostname on which the service should run",
    "port": "port number to listen for incoming connections",
    "client": "agent to handle requests",
}


def parse_opt(version: str) -> Namespace:
    parser = ArgumentParser(
        prog="declusor",
        description=(
            f"declusor {version}: a versatile payload delivery handler "
            "designed to manage the delivery of Bash script payloads "
            "to Linux machines."
        ),
        formatter_class=lambda prog: HelpFormatter(prog, max_help_position=30),
    )

    parser.add_argument("host", help=HELP["host"], type=str)
    parser.add_argument("port", help=HELP["port"], type=int)
    parser.add_argument(
        "-c", "--client", help=HELP["client"], type=str, default=CLIENT
    )

    return parser.parse_args()
