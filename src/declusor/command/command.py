from declusor import interface


class ExecuteCommand(interface.ICommand):
    def __init__(self, command_line: str) -> None:
        self._command_line = command_line.encode()

    async def execute(self, session: interface.ISession, /) -> None:
        await session.write(self._command_line)
