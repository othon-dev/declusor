import pytest


@pytest.fixture
def mock_config(monkeypatch: pytest.MonkeyPatch) -> None:
    """Mock config constants."""


def test_validate_file_extension_valid() -> None:
    """Test `validate_file_extension` with allowed extension."""


def test_validate_file_extension_invalid() -> None:
    """Test `validate_file_extension` with disallowed extension."""


def test_validate_file_extension_case_insensitivity() -> None:
    """Test `validate_file_extension` is case insensitive."""


def test_validate_file_relative_valid() -> None:
    """Test `validate_file_relative` with valid relative path."""


def test_validate_file_relative_invalid() -> None:
    """Test `validate_file_relative` with path outside base directory."""


def test_validate_file_extension_empty_allowed() -> None:
    """Test `validate_file_extension` with empty allowed extensions list."""


def test_validate_file_extension_no_extension() -> None:
    """Test `validate_file_extension` with file having no extension."""


def test_validate_file_relative_same_path() -> None:
    """Test `validate_file_relative` when path is same as base directory."""


def test_validate_file_relative_traversal() -> None:
    """Test `validate_file_relative` with traversal attempts (e.g. ..)."""


def test_validate_file_extension_complex_filename() -> None:
    """Test `validate_file_extension` with filenames containing multiple dots."""


def test_validate_file_extension_hidden_file() -> None:
    """Test `validate_file_extension` with hidden files (starting with dot)."""


def test_validate_file_extension_iterable_types() -> None:
    """Test `validate_file_extension` with different iterable types (set, tuple)."""


def test_validate_file_extension_path_input() -> None:
    """Test `validate_file_extension` with Path object input."""


def test_validate_file_relative_symlink_attack() -> None:
    """Test `validate_file_relative` with symlink pointing outside base directory."""


def test_validate_file_relative_unicode_paths() -> None:
    """Test `validate_file_relative` with paths containing unicode characters."""


def test_validate_file_relative_spaces() -> None:
    """Test `validate_file_relative` with paths containing spaces."""


def test_validate_file_relative_absolute_mismatch() -> None:
    """Test `validate_file_relative` mixing absolute file path with relative base."""


def test_validate_file_relative_non_existent() -> None:
    """Test `validate_file_relative` with non-existent paths."""


def test_validate_file_relative_root() -> None:
    """Test `validate_file_relative` using root directory as base."""
