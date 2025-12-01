from declusor.config import parse_opt
from declusor.main import run_service, handle_exception
from declusor.version import __version__, PROJECT_DESCRIPTION, PROJECT_NAME

if __name__ == "__main__":
    opt = parse_opt(PROJECT_NAME, PROJECT_DESCRIPTION, __version__)

    try:
        run_service(opt.host, opt.port, opt.client)
    except (Exception, KeyboardInterrupt) as err:
        handle_exception(err)
