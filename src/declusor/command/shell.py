from declusor import interface, util

import asyncio
from asyncio import Event


class LaunchShell(interface.ICommand):
    def __init__(self) -> None:
        self._stop_event = Event()

    async def execute(self, session: interface.ISession, /) -> None:
        input_task = asyncio.create_task(self._handle_command_request(session))
        socket_task = asyncio.create_task(self._handle_command_response(session))

        try:
            await asyncio.wait([input_task, socket_task], return_when=asyncio.FIRST_COMPLETED)
        except asyncio.CancelledError:
            pass
        finally:
            self._stop_event.set()

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

    async def _handle_command_request(self, session: interface.ISession) -> None:
        while not self._stop_event.is_set():
            try:
                command_request = await asyncio.to_thread(util.read_stripped_message)

                if command_request.strip():
                    await session.write(command_request.strip().encode())
            except EOFError:
                break

    async def _handle_command_response(self, session: interface.ISession) -> None:
        try:
            async for data in session.read():
                if self._stop_event.is_set():
                    break

                if data:
                    util.write_binary_data(data)
        finally:
            self._stop_event.set()
