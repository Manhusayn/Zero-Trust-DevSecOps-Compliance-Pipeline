pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  environment {
    IMAGE = "zero-trust-demo:${BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Unit Tests') { steps { sh 'python3 -m unittest discover -s tests -v' } }
    stage('SAST') { steps { sh 'semgrep scan --config .semgrep.yml --error' } }
    stage('Secrets') { steps { sh 'gitleaks detect --source . --redact' } }
    stage('Kubernetes Policy') { steps { sh 'conftest test k8s --policy policies/kubernetes' } }
    stage('Build') { steps { sh 'docker build --pull -t "$IMAGE" .' } }
    stage('Container Scan') { steps { sh 'trivy image --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed "$IMAGE"' } }
    stage('SBOM') { steps { sh 'syft "$IMAGE" -o cyclonedx-json > sbom.json' } }
    stage('Artifact Signing') {
      when { expression { return env.COSIGN_KEY != null && env.COSIGN_KEY.trim() != '' } }
      steps { sh 'cosign sign --yes --key "$COSIGN_KEY" "$IMAGE"' }
    }
  }
  post {
    always { archiveArtifacts artifacts: 'sbom.json', allowEmptyArchive: true }
  }
}
