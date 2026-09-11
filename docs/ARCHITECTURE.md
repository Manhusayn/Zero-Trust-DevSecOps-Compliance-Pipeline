# Architecture

```text
Developer
   │
   ▼
Git Repository
   │
   ▼
┌─────────────────────────────────────────────┐
│ CI Security Gates                           │
│                                             │
│ Tests → SAST → Secrets → Policy → Build     │
│                              │              │
│                       Trivy → SBOM → Sign   │
└──────────────────────────────┬──────────────┘
                               │
                         Approved Image
                               │
                               ▼
                         Container Registry
                               │
                               ▼
                         Kubernetes Cluster
                               │
             ┌─────────────────┴───────────────┐
             │ Restricted Pod + NetworkPolicy │
             └─────────────────────────────────┘
```
