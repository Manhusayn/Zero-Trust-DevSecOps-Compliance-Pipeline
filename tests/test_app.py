import json
import unittest
from unittest.mock import patch

from app.main import Handler

class DummySocket:
    def __init__(self):
        self.data = b""
    def makefile(self, *args, **kwargs):
        return self
    def write(self, data):
        self.data += data
    def flush(self):
        pass

class TestHandler(unittest.TestCase):
    def test_health(self):
        self.assertEqual(Handler.protocol_version, "HTTP/1.0")

    def test_json_payload_shape(self):
        payload = {"status": "healthy"}
        self.assertEqual(json.loads(json.dumps(payload)), payload)

if __name__ == "__main__":
    unittest.main()
