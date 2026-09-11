# Threat Model

## Assets
- Source code and CI credentials
- Container image
- Kubernetes workload
- Build artifacts / SBOM

## Trust boundaries
1. Developer workstation → Git repository
2. Git repository → CI runner
3. CI runner → container registry
4. Registry → Kubernetes cluster
5. Workload → Kubernetes API / network

## Controls
- Least-privilege CI permissions
- Secret detection before artifact promotion
- SAST before build
- Kubernetes policy-as-code gate
- Non-root, restricted container runtime
- Read-only root filesystem
- Dropped Linux capabilities
- Disabled service-account token automount
- Default-deny network policy
- Vulnerability gate for HIGH/CRITICAL findings
- SBOM generation
- Optional Cosign signing

## Zero-trust principle
No stage is trusted merely because it is inside the pipeline. Every artifact and deployment boundary is independently validated before promotion.
