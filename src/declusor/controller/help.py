from declusor import interface, util


async def call_help(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Display help information about available commands."""

    if line:
        util.write_string_message(router.get_route_usage(line))
    else:
        util.write_string_message(router.documentation)
