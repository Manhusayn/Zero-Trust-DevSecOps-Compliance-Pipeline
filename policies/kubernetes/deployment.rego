package kubernetes.deployment

violation[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.securityContext.runAsNonRoot
  msg := sprintf("container %q must set securityContext.runAsNonRoot=true", [c.name])
}

violation[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.securityContext.allowPrivilegeEscalation == false
  msg := sprintf("container %q must disable privilege escalation", [c.name])
}

violation[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.cpu
  msg := sprintf("container %q must define a CPU limit", [c.name])
}

violation[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.memory
  msg := sprintf("container %q must define a memory limit", [c.name])
}
