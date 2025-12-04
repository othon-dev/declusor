"""Tests for declusor.controller.help module.

This module tests the help controller:
- call_help: Controller that displays help for all commands or a specific command
"""

from unittest.mock import AsyncMock, MagicMock

import pytest


# =============================================================================
# Fixtures
# =============================================================================


@pytest.fixture
def mock_session() -> AsyncMock:
    """Create a mock ISession."""


@pytest.fixture
def mock_router() -> MagicMock:
    """Create a mock IRouter with documentation property and get_route_usage method."""


@pytest.fixture
def mock_console(monkeypatch: pytest.MonkeyPatch) -> MagicMock:
    """Mock core.console for output verification."""


# =============================================================================
# Tests: call_help - No arguments (global help)
# =============================================================================


@pytest.mark.asyncio
async def test_call_help_no_args_displays_all_commands(
    mock_session: AsyncMock, mock_router: MagicMock, mock_console: MagicMock
) -> None:
    """
    Given: call_help is called with empty line ""
    When: Controller executes
    Then: Displays router.documentation (all commands)
    """


@pytest.mark.asyncio
async def test_call_help_no_args_uses_router_documentation(
    mock_session: AsyncMock, mock_router: MagicMock
) -> None:
    """
    Given: call_help is called with empty line
    When: Controller executes
    Then: Accesses router.documentation property
    """


@pytest.mark.asyncio
async def test_call_help_no_args_writes_to_console(
    mock_session: AsyncMock, mock_router: MagicMock, mock_console: MagicMock
) -> None:
    """
    Given: call_help is called with empty line
    When: Documentation is retrieved
    Then: console.write_message is called with documentation
    """


# =============================================================================
# Tests: call_help - With command argument
# =============================================================================


@pytest.mark.asyncio
async def test_call_help_with_command_displays_specific_help(
    mock_session: AsyncMock, mock_router: MagicMock, mock_console: MagicMock
) -> None:
    """
    Given: call_help is called with line="load"
    When: Controller executes
    Then: Displays help for "load" command only
    """


@pytest.mark.asyncio
async def test_call_help_with_command_uses_get_route_usage(
    mock_session: AsyncMock, mock_router: MagicMock
) -> None:
    """
    Given: call_help is called with line="shell"
    When: Controller executes
    Then: Calls router.get_route_usage("shell")
    """


@pytest.mark.asyncio
async def test_call_help_invalid_command_raises(
    mock_session: AsyncMock, mock_router: MagicMock
) -> None:
    """
    Given: call_help is called with line="nonexistent"
    When: get_route_usage raises RouterError
    Then: RouterError propagates up
    """


# =============================================================================
# Tests: call_help - Argument parsing
# =============================================================================


@pytest.mark.asyncio
async def test_call_help_parses_optional_command_arg(mock_session: AsyncMock, mock_router: MagicMock) -> None:
    """
    Given: call_help uses parse_command_arguments with Optional[str]
    When: No argument provided
    Then: arguments["command"] is None
    """


@pytest.mark.asyncio
async def test_call_help_parses_provided_command_arg(mock_session: AsyncMock, mock_router: MagicMock) -> None:
    """
    Given: call_help is called with line="upload"
    When: Arguments are parsed
    Then: arguments["command"] is "upload"
    """
