from base64 import b64encode, b64decode


def convert_bytes_to_hex(data: bytes, /) -> str:
    """
    Convert a bytes object to its hexadecimal string representation.

    Args:
        data: The bytes object to convert.

    Returns:
        The hexadecimal string representation of the bytes.
    """

    return "".join(f"\\x{i:02x}" for i in data)


def convert_to_base64(data: str | bytes, /) -> str:
    """
    Convert a string to its Base64 encoded representation.

    Args:
        data: The string or bytes object to convert.

    Returns:
        The Base64 encoded string.
    """

    return b64encode(data.encode() if isinstance(data, str) else data).decode()


def convert_base64_to_bytes(data: str, /) -> bytes:
    """
    Convert a Base64 encoded string back to its original bytes representation.

    Args:
        data: The Base64 encoded string to convert.

    Returns:
        The original bytes representation.
    """

    return b64decode(data)
