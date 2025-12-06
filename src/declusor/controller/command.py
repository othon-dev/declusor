from declusor import command, interface, util


async def call_command(session: interface.ISession, console: interface.IConsole, line: str) -> None:
    """Execute a single command on the remote system."""

    arguments, _ = util.parse_command_arguments(line, {"command": str})
    command_line = arguments["command"]

    await command.ExecuteCommand(command_line).execute(session, console)

    async for data in session.read():
        console.write_binary_data(data)
