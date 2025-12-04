from declusor import schema, interface, util

from pathlib import Path


class StoreFile(interface.ICommand):
    FUNCTION_NAME = schema.STORE_FILE_FUNCTION

    def __init__(self, filepath: str | Path) -> None:
        self._filepath = util.ensure_file_exists(filepath)

    @property
    def command(self) -> bytes:
        file_content = util.load_file(self._filepath)
        file_base64 = util.convert_to_base64(file_content)

        return util.format_function_call(schema.STORE_FILE_FUNCTION, file_base64).encode()

    async def send(self, session: interface.ISession) -> None:
        await session.write(self.command)
