package kubernetes.namespace

violation[msg] {
  input.kind == "Namespace"
  input.metadata.labels["pod-security.kubernetes.io/enforce"] != "restricted"
  msg := "namespace must enforce Kubernetes restricted Pod Security Standard"
}
