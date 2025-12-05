from declusor import config, interface


class PromptCLI(interface.IPrompt):
    """CLI prompt implementation."""

    def __init__(self, name: str, router: interface.IRouter, session: interface.ISession, console: interface.IConsole) -> None:
        self._prompt = f"[{name}] "

        self._router = router
        self._session = session
        self._console = console

    async def read_command(self) -> str:
        """Read command from user input."""

        while not (command := await self._console.read_stripped_line(self._prompt)):
            continue

        return command

    async def handle_route(self, command: str) -> None:
        """Handle routing based on user command."""

        match command.split(" ", 1):
            case [route, argument]:
                await self._router.locate(route)(self._session, self._console, argument.strip())
            case [route]:
                await self._router.locate(route)(self._session, self._console, "")
            case _:
                self._console.write_error_message(command)

    async def run(self) -> None:
        """Run the CLI prompt loop."""

        while True:
            try:
                await self.handle_route(await self.read_command())
            except (config.ExitRequest, KeyboardInterrupt):
                break
            except config.DeclusorException as e:
                self._console.write_error_message(str(e))
