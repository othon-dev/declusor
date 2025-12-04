import pytest


@pytest.fixture
def mock_config(monkeypatch: pytest.MonkeyPatch) -> None:
    """Mock config constants."""


def test_await_connection_success() -> None:
    """Test `await_connection` successfully yields a connection."""


def test_await_connection_socket_error() -> None:
    """Test `await_connection` handles socket errors via _handle_socket_exception."""
