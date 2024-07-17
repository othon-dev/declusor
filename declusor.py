#!/usr/bin/env python3

import src as declusor


def main() -> None:
    opt = declusor.parse_opt(declusor.__version__)

    try:
        declusor.run_service(opt.host, opt.port, opt.client)
    except (Exception, KeyboardInterrupt) as err:
        declusor.handle_exception(err)


if __name__ == "__main__":
    main()
