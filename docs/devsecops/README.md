# Phase 1 DevSecOps

This repository implements Phase 1 DevSecOps controls in the application CI pipeline.

## What Phase 1 adds

- Gitleaks secret scanning in GitHub Actions.
- SonarQube Community Edition code quality analysis.
- Minimal unit test execution before SonarQube quality evaluation.
- Gated Docker build, registry publish, and deployment flow.

## Pipeline order

1. Checkout repository.
2. Gitleaks scan.
3. Restore dependencies.
4. Build application and test project.
5. Run unit tests.
6. SonarQube analysis.
7. SonarQube quality gate wait/check.
8. Docker build.
9. ACR publish.
10. AKS deployment and verification.

## Required GitHub secrets

- `SONAR_HOST_URL`: URL of the self-hosted SonarQube server.
- `SONAR_TOKEN`: SonarQube analysis token for this project.

## Optional GitHub secrets

- `GITLEAKS_LICENSE`: Only required if the repository is owned by a GitHub organization and the official Gitleaks action requests the free license key.

## Branch protection guidance

Use these checks where applicable:

- `Gitleaks Scan`
- `SonarQube Quality Gate`

## Important SonarQube Community Edition limitation

SonarQube Community Edition does not support full pull request analysis or multi-branch analysis in GitHub Actions. In this repository, SonarQube analysis is executed for the `dev` push pipeline, while pull requests still receive the `Gitleaks Scan` gate.

## Future expansion

This structure is intentionally compatible with later additions such as:

- Trivy
- OWASP Dependency-Check
- SBOM generation
- Container image scanning
- Additional quality/security jobs
