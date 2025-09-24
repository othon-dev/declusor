import controller
from interfaces import IRouter


def set_routes(router: IRouter) -> None:
    router.connect("load", controller.call_load)
    router.connect("command", controller.call_command)
    router.connect("shell", controller.call_shell)
    router.connect("upload", controller.call_upload)
    router.connect("execute", controller.call_execute)
    router.connect("help", controller.call_help)
    router.connect("exit", controller.call_exit)
