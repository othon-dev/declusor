from declusor import command, interface, util


async def call_execute(session: interface.ISession, console: interface.IConsole, line: str) -> None:
    """Execute a program or script from the local system on the remote system."""

    arguments, _ = util.parse_command_arguments(line, {"filepath": str})
    filepath = util.ensure_file_exists(arguments["filepath"])

    await command.ExecuteFile(filepath).execute(session, console)

    async for data in session.read():
        console.write_binary_data(data)
