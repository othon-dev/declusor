import unittest
from unittest.mock import MagicMock

from declusor.controller.exit import call_exit


class TestExitController(unittest.TestCase):
    def test_exit_raises_system_exit(self) -> None:
        with self.assertRaises(SystemExit):
            call_exit(MagicMock(), MagicMock(), "")


if __name__ == "__main__":
    unittest.main()
