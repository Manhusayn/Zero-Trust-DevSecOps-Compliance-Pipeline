package kubernetes.namespace

violation contains msg if {
    input.kind == "Namespace"
    input.metadata.labels["pod-security.kubernetes.io/enforce"] != "restricted"
    msg := "namespace must enforce Kubernetes restricted Pod Security Standard"
}
