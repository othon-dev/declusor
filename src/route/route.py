import controllers
from interfaces import IRouter


def set_routes(router: IRouter) -> None:
    router.connect("load", controllers.load_controller)
    router.connect("command", controllers.command_controller)
    router.connect("shell", controllers.shell_controller)
    router.connect("upload", controllers.upload_controller)
    router.connect("execute", controllers.execute_controller)
    router.connect("help", controllers.help_controller)
    router.connect("exit", controllers.exit_controller)
