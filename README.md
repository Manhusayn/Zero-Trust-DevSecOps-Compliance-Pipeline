# 🛡️ Zero-Trust DevSecOps Compliance Pipeline

> **Project 2 — Enterprise DevSecOps Portfolio Project**
>
> Build → verify → scan → enforce → generate SBOM → optionally sign → deploy with zero-trust defaults.

![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Policy--as--Code-326CE5?logo=kubernetes)
![Security](https://img.shields.io/badge/Security-Zero--Trust-111827)
![CI](https://img.shields.io/badge/CI-GitHub%20Actions%20%7C%20Jenkins-2ea44f)

## 🎯 What this project demonstrates

This repository implements a realistic security gate around a small production-style Python service using only the Python standard library. A change is not treated as trusted simply because it came from the source repository: it must pass independent controls before becoming a deployable artifact.

**Pipeline:**

`Code → Test → SAST → Secret Scan → K8s Policy → Build → CVE Scan → SBOM → Sign → Deploy`

## 🧠 Zero-Trust controls

| Layer | Control | Why |
|---|---|---|
| Code | Pytest | Prevent broken changes |
| Code | Semgrep | Detect insecure coding patterns |
| Git | Gitleaks | Stop secrets entering the pipeline |
| Kubernetes | Conftest + OPA | Enforce deployment policy |
| Image | Non-root user | Reduce container privilege |
| Image | Read-only root FS | Reduce write/escape surface |
| Runtime | Drop ALL capabilities | Least privilege |
| Runtime | No service-account token | Reduce API credential exposure |
| Network | Default-deny NetworkPolicy | Explicit network trust |
| Supply chain | Trivy | Block HIGH/CRITICAL image/filesystem risk |
| Supply chain | SBOM | Software inventory / traceability |
| Supply chain | Cosign | Optional artifact signing |

## 📁 Repository

```text
.
├── app/                         # Flask application
├── tests/                       # Unit tests
├── k8s/                         # Restricted Kubernetes manifests
├── policies/kubernetes/         # OPA/Rego compliance rules
├── scripts/                    # Local security tooling
├── docs/                        # Architecture + threat model
├── .github/workflows/           # GitHub Actions pipeline
├── Jenkinsfile                 # Jenkins equivalent pipeline
├── Dockerfile                  # Hardened container image
├── Makefile                    # Developer shortcuts
└── README.md
```

## 🚀 Quick start

### 1. Clone

```bash
git clone https://github.com/Manhusayn/Zero-Trust-DevSecOps-Compliance-Pipeline
cd Zero-Trust-DevSecOps-Compliance-Pipeline
```

### 2. Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

No third-party Python runtime dependency is required.

### 3. Run tests

```bash
make test
```

Expected result: **2 tests passed**.

### 4. Run the service

```bash
python -m app.main
```

Then:

```bash
curl http://127.0.0.1:8080/health
curl http://127.0.0.1:8080/api/v1/info
```

### 5. Validate Kubernetes compliance

Install OPA Conftest, then:

```bash
make policy
```

A compliant manifest should return `0 violations`.

### 6. Build the image

```bash
make build
```

### 7. Run the complete local gate

After installing `pytest`, `gitleaks`, `conftest`, and `trivy`:

```bash
./scripts/security-gate.sh
```

The gate fails fast if any mandatory control fails.

## 🔐 Kubernetes hardening

The deployment intentionally uses:

- `runAsNonRoot: true`
- `seccompProfile: RuntimeDefault`
- `allowPrivilegeEscalation: false`
- `capabilities.drop: [ALL]`
- `readOnlyRootFilesystem: true`
- CPU and memory limits
- `automountServiceAccountToken: false`
- Kubernetes **Restricted** Pod Security enforcement
- default-deny ingress/egress network policy

## 🔄 GitHub Actions

`.github/workflows/devsecops.yml` runs on pushes and pull requests and executes:

1. Unit tests
2. Semgrep SAST
3. Gitleaks
4. OPA/Conftest policy checks
5. Docker build
6. Trivy image scan
7. CycloneDX SBOM generation
8. SBOM artifact upload

The workflow requests only `contents: read` permissions by default.

## 🏗️ Jenkins

`Jenkinsfile` provides the same security model for Jenkins environments and adds an optional Cosign signing stage.

Configure `COSIGN_KEY` as a protected Jenkins credential only when artifact signing is required. The signing stage is skipped when the credential is absent, so the base pipeline remains runnable in a local lab.

## ☸️ Deploy to a local Kubernetes cluster

Build the image and load/tag it using the mechanism supported by your cluster. For example, with a local cluster that can see the local Docker image:

```bash
docker build -t zero-trust-demo:local .
kubectl apply -f k8s/
kubectl -n zero-trust-demo get pods,svc
```

For **kind**, load the image before applying the deployment:

```bash
kind load docker-image zero-trust-demo:local
kubectl apply -f k8s/
```

## 🧪 Intentional security-failure demo

To prove that the compliance gate actually protects the system, temporarily change:

```yaml
allowPrivilegeEscalation: false
```

to:

```yaml
allowPrivilegeEscalation: true
```

Then run:

```bash
conftest test k8s --policy policies/kubernetes
```

The pipeline should fail. Restore the secure value afterward.

## 📊 Interview explanation

> “I designed the pipeline so trust is continuously re-established at every boundary. Source changes first pass tests, SAST and secret detection. Kubernetes manifests are checked against OPA policies before deployment. The image is rebuilt from a minimal non-root base, scanned for high and critical vulnerabilities, and an SBOM is produced for supply-chain visibility. At runtime, the workload uses restricted Pod Security settings, no automatic service-account token, dropped capabilities, a read-only filesystem and default-deny networking. Artifact signing can be enabled with Cosign. Therefore, passing one stage does not make later stages trusted; each boundary has its own control.”

## 📚 Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Threat Model](docs/THREAT-MODEL.md)

## ⚠️ Production notes

This is a portfolio/lab implementation, not a complete enterprise compliance platform. Production environments should additionally integrate centralized identity, short-lived credentials, a registry admission controller, keyless signing/verification, vulnerability exceptions with approval workflow, centralized audit logs, secrets management, runtime detection, and organization-specific compliance policies.

## ⭐ Portfolio value

This project gives you one end-to-end story covering **DevSecOps + Kubernetes security + supply-chain security + policy-as-code + CI/CD + zero-trust principles** rather than a collection of disconnected tools.
