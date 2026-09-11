#!/usr/bin/env bash
set -euo pipefail

printf '\n[1/5] Unit tests\n'
python3 -m unittest discover -s tests -v

printf '\n[2/5] Python syntax\n'
python3 -m compileall -q app tests

printf '\n[3/5] Secret scan\n'
gitleaks detect --source . --redact

printf '\n[4/5] IaC/Kubernetes policy\n'
conftest test k8s --policy policies/kubernetes

printf '\n[5/5] Filesystem vulnerability scan\n'
trivy fs --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed .

printf '\nSecurity gate: PASS\n'
