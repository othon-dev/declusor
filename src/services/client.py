from os.path import join
from string import Template

from config import CLIENTS_DIR, SRV_ACK
from services.argument import format_bash_arguments


def format_bytes_to_string(data: bytes) -> str:
    return "".join(f"\\x{i:02x}" for i in data)


def format_client_code(filepath: str, **kwargs: str | int) -> str:
    client_code = str()

    with open(join(CLIENTS_DIR, filepath), "r") as f:
        for line in f.readlines():
            if not line.lstrip().startswith("#"):
                client_code += line

    kwargs.update(dict(acknowledge=format_bytes_to_string(SRV_ACK)))

    client_code = " ".join(client_code.split())
    client_code = Template(client_code).safe_substitute(
        **format_bash_arguments(**kwargs)
    )

    return client_code
