from declusor import error, interface, util


async def call_load(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Load a payload from a file and send it to the remote system."""

    arguments, _ = util.parse_command_arguments(line, {"payload": str})

    if (payload := util.try_load_file(arguments["payload"])) is None:
        raise error.ControllerError("failed to load file content: " + arguments["payload"])

    await session.write(payload)

    async for data in session.read():
        util.write_binary_data(data)
