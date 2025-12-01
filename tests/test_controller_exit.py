import unittest
from unittest.mock import MagicMock
import sys
import os

from declusor.controller.exit import call_exit


class TestExitController(unittest.TestCase):
    def test_exit_raises_system_exit(self):
        with self.assertRaises(SystemExit):
            call_exit(MagicMock(), MagicMock(), "")


if __name__ == "__main__":
    unittest.main()
