import unittest

from declusor.util import encoding


class TestFormatUtil(unittest.TestCase):
    def test_convert_bytes_to_hex(self) -> None:
        """Test converting bytes to hex string representation."""

        self.assertEqual(encoding.convert_bytes_to_hex(b"abc"), "\\x61\\x62\\x63")
        self.assertEqual(encoding.convert_bytes_to_hex(b""), "")
