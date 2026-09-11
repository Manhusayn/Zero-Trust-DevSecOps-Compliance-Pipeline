package kubernetes.serviceaccount

violation contains msg if {
    input.kind == "ServiceAccount"
    input.automountServiceAccountToken == true
    msg := sprintf("service account %q must not auto-mount API tokens", [input.metadata.name])
}
