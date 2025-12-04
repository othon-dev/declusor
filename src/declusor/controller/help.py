from typing import Optional

from declusor import interface, util


async def call_help(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Display help information about available commands."""

    arguments, _ = util.parse_command_arguments(line, {"command": Optional[str]})

    if arguments["command"]:
        util.write_string_message(router.get_route_usage(arguments["command"]))
    else:
        util.write_string_message(router.documentation)
