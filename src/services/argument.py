import shlex
from argparse import ArgumentParser
from typing import NoReturn

from config import ArgumentParsingError


class CustomArgumentParser(ArgumentParser):
    def error(self, message: str) -> NoReturn:
        raise ArgumentParsingError(message)


def parse_arguments(
    line: str,
    args: dict[str, type],
    split: bool = False,
    allow_unknown: bool = False,
) -> tuple[dict[str, str], list[str]]:

    if not args and not line.strip():
        return {}, []

    parser = CustomArgumentParser(add_help=False, exit_on_error=False)

    for arg_name, arg_type in args.items():
        if arg_type not in [str, int]:
            raise TypeError(f"{arg_type!r} is not supported.")

        parser.add_argument(arg_name, type=arg_type)

    parser_args = shlex.split(line) if split else line.split(maxsplit=0)

    if allow_unknown:
        arguments, unknown_arguments = parser.parse_known_args(parser_args)
    else:
        arguments = parser.parse_args(parser_args)
        unknown_arguments = []

    return {
        k: str(v).strip() for k, v in vars(arguments).items()
    }, unknown_arguments


def format_bash_arguments(**kwargs: str) -> dict[str, str]:
    return {k.upper(): str(v) for k, v in kwargs.items()}
