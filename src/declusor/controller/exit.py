from declusor import config, interface


async def call_exit(session: interface.ISession, console: interface.IConsole, line: str) -> None:
    """Terminate the session and exit the program."""

    raise config.ExitRequest
