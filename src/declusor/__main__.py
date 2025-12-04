import asyncio

from declusor.core import DeclusorParser
from declusor.main import handle_exception, run_service
from declusor.version import PROJECT_DESCRIPTION, PROJECT_NAME, __version__

if __name__ == "__main__":
    opt = DeclusorParser(PROJECT_NAME, PROJECT_DESCRIPTION, __version__).parse()

    try:
        asyncio.run(run_service(opt["host"], opt["port"], opt["client"]))
    except (Exception, KeyboardInterrupt) as err:
        handle_exception(err)
