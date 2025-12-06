import asyncio

from declusor import core, main, version

if __name__ == "__main__":
    options = core.DeclusorParser(version.PROJECT_NAME, version.PROJECT_DESCRIPTION, version.__version__).parse()
    console = core.Console()

    try:
        asyncio.run(main.run_service(options, console))
    except Exception as e:
        main.handle_exception(e)
    except KeyboardInterrupt:
        pass
