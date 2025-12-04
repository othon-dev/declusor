from declusor import interface, util


async def call_command(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Execute a command on the remote system."""

    arguments, _ = util.parse_command_arguments(line, {"command": str})

    await session.write(arguments["command"].encode())

    async for data in session.read():
        util.write_binary_data(data)
