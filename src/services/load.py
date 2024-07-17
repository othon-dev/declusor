from os import scandir
from os.path import exists, isfile, join, splitext

from config import LIBRARY_DIR, PAYLOAD_DIR, InvalidArgument


def load_payload(module: str) -> bytes:
    if (extension := splitext(module)[1].casefold()) != ".sh":
        raise InvalidArgument(f"{extension!r} is not supported")

    module_filepath = join(PAYLOAD_DIR, module)

    if not exists(module_filepath):
        raise InvalidArgument(f"file not found: {module}")

    if not isfile(module_filepath):
        raise InvalidArgument(f"expecting a file: {module}")

    # # uncomment to restrict third-party payloads
    #
    # from os.path import commonpath
    # if commonpath([PAYLOAD_DIR, module_filepath]) != PAYLOAD_DIR:
    #     raise InvalidArgument(module)

    with open(module_filepath, "rb") as f:
        return f.read()


def load_library() -> bytes:
    modules = []

    for file in scandir(LIBRARY_DIR):
        if not file.is_file():
            continue

        if not file.name.casefold().endswith(".sh"):
            continue

        modules.append(load_file(file.path))

    return b"\n\n".join(modules)


def load_file(filepath: str) -> bytes:
    if not exists(filepath):
        raise InvalidArgument(f"file not found: {filepath}")

    elif not isfile(filepath):
        raise InvalidArgument(f"expecting a file: {filepath}")

    else:
        with open(filepath, "rb") as f:
            return f.read()
