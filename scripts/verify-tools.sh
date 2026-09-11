#!/usr/bin/env bash
set -euo pipefail
missing=0
for tool in python3 git docker trivy conftest; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  ✓ %s\n' "$tool"
  else
    printf '  ✗ %s (missing)\n' "$tool"
    missing=1
  fi
done
exit "$missing"
