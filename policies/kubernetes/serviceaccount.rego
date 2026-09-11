package kubernetes.serviceaccount

violation[msg] {
  input.kind == "ServiceAccount"
  input.automountServiceAccountToken == true
  msg := sprintf("service account %q must not auto-mount API tokens", [input.metadata.name])
}
