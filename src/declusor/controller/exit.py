from declusor import error, interface


async def call_exit(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Exit the program."""

    raise error.ExitRequest
