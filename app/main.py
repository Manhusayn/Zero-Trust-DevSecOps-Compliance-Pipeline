import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HOST = "0.0.0.0"
PORT = int(os.getenv("PORT", "8080"))
VERSION = os.getenv("APP_VERSION", "dev")

class Handler(BaseHTTPRequestHandler):
    def _json(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            self._json(200, {"status": "healthy"})
        elif self.path == "/api/v1/info":
            self._json(200, {"service": "zero-trust-demo", "version": VERSION})
        else:
            self._json(404, {"error": "not_found"})

    def log_message(self, format, *args):
        return


def create_server():
    return ThreadingHTTPServer((HOST, PORT), Handler)


if __name__ == "__main__":
    with create_server() as server:
        print(f"zero-trust-demo listening on {HOST}:{PORT}")
        server.serve_forever()
