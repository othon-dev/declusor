from interfaces import IRouter, ISession


def exit_controller(session: ISession, router: IRouter, line: str) -> None:
    """Log out from the current terminal session"""

    raise SystemExit
