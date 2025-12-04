from declusor import interface, util, core, schema


async def call_upload(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Upload a file to the target machine."""

    arguments, _ = util.parse_command_arguments(line, {"filepath": str})

    if (file_content := util.try_load_file(arguments["filepath"])) is None:
        raise core.ControllerError("Failed to load the specified file.")

    file_base64 = util.convert_to_base64(file_content)
    function_call = util.format_function_call(schema.STORE_FILE_FUNCTION, file_base64)

    await session.write(function_call.encode())

    async for data in session.read():
        util.write_binary_data(data)
