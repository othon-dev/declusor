from os import chdir
from typing import Callable, Type

from declusor import config, controller, core, interface, util

__all__ = ["run"]


def handle_exception(exc: BaseException) -> None:
    """Handle exceptions and exit the program with an appropriate message."""

    handler_table: dict[Type[BaseException], Callable[[BaseException], str]] = {
        FileNotFoundError: lambda e: f"file or directory not found: {e}",
        NotADirectoryError: lambda e: f"not a directory: {e}",
        OSError: str,
    }

    for exception_type, get_message in handler_table.items():
        if isinstance(exc, exception_type):
            sysexit = SystemExit(get_message(exc))
            sysexit.code = 1

            raise sysexit

    raise exc


def set_routes(router: interface.IRouter) -> None:
    """Set up the routes for the router."""

    call_help = controller.create_help_controller(lambda: router.documentation, router.get_route_usage)

    router.connect("help", call_help)
    router.connect("load", controller.call_load)
    router.connect("command", controller.call_command)
    router.connect("shell", controller.call_shell)
    router.connect("upload", controller.call_upload)
    router.connect("execute", controller.call_execute)
    router.connect("exit", controller.call_exit)


def run_service(router: interface.IRouter, console: interface.IConsole, options: config.DeclusorOptions) -> None:
    """Run the main service loop."""

    directories = [config.BasePath.CLIENTS_DIR, config.BasePath.MODULES_DIR, config.BasePath.LIBRARY_DIR]

    for directory in directories:
        if directory.exists():
            if not directory.is_dir():
                raise NotADirectoryError(directory)
        else:
            raise FileNotFoundError(directory)

    chdir(config.BasePath.MODULES_DIR)
    set_routes(router)

    console.setup_completer(router.routes)
    console.write_message(util.format_client_script(options["client"], HOST=options["host"], PORT=options["port"]))

    with util.await_connection(options["host"], options["port"]) as conn:
        session = core.SocketSession(conn)
        prompt = core.PromptCLI(config.Settings.PROJECT_NAME, router, session, console)

        session.initialize(util.load_library())

        try:
            prompt.run()
        finally:
            session.close()


def run() -> None:
    """Main entry point for the Declusor application."""

    router = core.Router()
    options = core.DeclusorParser(config.Settings.PROJECT_NAME, description=config.Settings.PROJECT_DESCRIPTION).parse()
    console = core.Console()

    try:
        run_service(router, console, options)
    except KeyboardInterrupt:
        print()
    except Exception as e:
        handle_exception(e)
