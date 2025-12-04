from base64 import b64encode

from declusor import error, interface, util


async def call_upload(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Upload a file to the target machine."""

    arguments, _ = util.parse_command_arguments(line, {"filepath": str})

    if (file_content := util.try_load_file(arguments["filepath"])) is None:
        raise error.ControllerError("failed to load file content: " + arguments["filepath"])

    function_call = util.format_function_call("bash", "store_base64_encoded_value", b64encode(file_content).decode())

    await session.write(function_call.encode())

    async for data in session.read():
        util.write_binary_data(data)
