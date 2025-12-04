import asyncio
from asyncio import Event

from declusor import interface, util


async def call_shell(session: interface.ISession, router: interface.IRouter, line: str) -> None:
    """Open an interactive shell session with the target device."""

    util.parse_command_arguments(line, {})

    stop_event = Event()

    input_task = asyncio.create_task(handle_input_data(session, stop_event))
    socket_task = asyncio.create_task(handle_socket_data(session, stop_event))

    try:
        await asyncio.wait([input_task, socket_task], return_when=asyncio.FIRST_COMPLETED)

    except asyncio.CancelledError:
        pass
    finally:
        stop_event.set()

        input_task.cancel()
        socket_task.cancel()

        try:
            await input_task
        except asyncio.CancelledError:
            pass
        try:
            await socket_task
        except asyncio.CancelledError:
            pass


async def handle_input_data(session: interface.ISession, stop_event: Event) -> None:
    """Handle input data from the user."""

    while not stop_event.is_set():
        # Run blocking input in a separate thread
        try:
            command = await asyncio.to_thread(util.read_stripped_message)

            if command.strip():
                await session.write(command.strip().encode())
        except EOFError:
            break


async def handle_socket_data(session: interface.ISession, stop_event: Event) -> None:
    """Handle socket data from the target device."""

    try:
        async for data in session.read():
            if stop_event.is_set():
                break
            if data:
                util.write_binary_data(data)
    except Exception:
        pass
    finally:
        stop_event.set()
