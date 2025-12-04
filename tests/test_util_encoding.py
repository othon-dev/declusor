import pytest


@pytest.fixture
def mock_config(monkeypatch: pytest.MonkeyPatch) -> None:
    """Mock config constants."""


def test_convert_bytes_to_hex() -> None:
    """Test converting bytes to hex string."""


def test_convert_to_base64_from_str() -> None:
    """Test converting string to base64."""


def test_convert_to_base64_from_bytes() -> None:
    """Test converting bytes to base64."""


def test_convert_base64_to_bytes() -> None:
    """Test converting base64 string back to bytes."""
