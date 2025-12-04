from declusor import interface, util, command


async def call_shell(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Open an interactive shell session with the target device."""

    util.parse_command_arguments(line, {})

    try:
        await command.LaunchShell().execute(session)
    except BaseException as e:
        print(type(e), str(e))
