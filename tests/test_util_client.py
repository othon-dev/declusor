import pytest


@pytest.fixture
def mock_config(monkeypatch: pytest.MonkeyPatch) -> None:
    """Mock config constants."""


def test_format_client_script_substitution(mock_config: None) -> None:
    """Test that `format_client_script` correctly substitutes variables."""


def test_format_client_script_safe_substitution(mock_config: None) -> None:
    """Test that `format_client_script` handles missing variables safely."""


def test_format_function_call_bash() -> None:
    """Test `format_function_call` with bash language."""


def test_format_function_call_sh() -> None:
    """Test `format_function_call` with sh language."""


def test_format_function_call_unsupported_language() -> None:
    """Test `format_function_call` raises error for unsupported language."""


def test_format_function_call_escaping() -> None:
    """Test `format_function_call` formatting handles complex escaping."""
