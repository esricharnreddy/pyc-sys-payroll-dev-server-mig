# DevSecOps Troubleshooting

## Gitleaks job fails

Possible causes:

- A real secret exists in the current diff or repository history.
- Secret-like sample data matches default Gitleaks rules.
- Organization-owned repository is missing the optional `GITLEAKS_LICENSE` secret.

Resolution:

1. Review the job summary and SARIF output.
2. Rotate any real secret immediately.
3. Remove the secret from source and history where necessary.
4. Add narrowly scoped allow rules only after review.

## SonarQube job fails before analysis

Possible causes:

- `SONAR_HOST_URL` is missing.
- `SONAR_TOKEN` is missing or invalid.
- SonarQube server is unreachable from GitHub-hosted runners.

Resolution:

1. Verify both GitHub secrets are present.
2. Confirm the SonarQube URL is reachable.
3. Confirm the token can analyze the project.

## SonarQube quality gate fails

Possible causes:

- New bugs, vulnerabilities, or code smells exceed the gate threshold.
- Coverage or maintainability thresholds fail.

Resolution:

1. Open the SonarQube project dashboard.
2. Review failed conditions in the quality gate.
3. Fix code issues and rerun the pipeline.

## SonarQube does not run on pull requests

This is expected for Community Edition in this Phase 1 design.

Resolution:

- Use `Gitleaks Scan` as the PR gate.
- Use `SonarQube Quality Gate` on `dev` push validation.
- Upgrade to SonarQube Developer Edition or higher if PR analysis is required.

## dotnet test fails locally

Possible causes:

- .NET SDK is not installed.
- `dotnet` is not on the shell PATH.

Resolution:

1. Install .NET 8 SDK.
2. Open a new shell after installation.
3. Run:

```powershell
dotnet test PayrollApp.Tests/PayrollApp.Tests.csproj --configuration Release
```

## GitHub code scanning upload is missing

Possible causes:

- `security-events: write` permission is missing.
- SARIF file was not generated.

Resolution:

1. Verify workflow permissions include `security-events: write`.
2. Confirm `gitleaks.sarif` exists in the workflow workspace.
3. Review upload step logs for SARIF parsing errors.
