# Gitleaks Setup

## Purpose

Gitleaks scans the repository history and working tree for hardcoded secrets such as:

- API keys
- Passwords
- Connection strings
- Azure credentials
- GitHub tokens
- JWT secrets
- Private keys

## Workflow behavior

The GitHub Actions workflow runs Gitleaks before restore, build, test, SonarQube, Docker build, and deployment.

If a leak is found:

- The job fails.
- A SARIF report is generated.
- GitHub code scanning upload is attempted.

## Official action

This repository uses the official `gitleaks/gitleaks-action` in CI.

## Optional license note

For repositories owned by a GitHub organization, the official Gitleaks action may require a free `GITLEAKS_LICENSE` secret from gitleaks.io. Personal-account repositories do not require it.

## Local usage

If Gitleaks is installed locally:

```powershell
gitleaks git .
```

Generate a SARIF report locally:

```powershell
gitleaks git . --report-format sarif --report-path gitleaks.sarif
```

Using Docker:

```powershell
docker run --rm -v ${PWD}:/repo -w /repo ghcr.io/gitleaks/gitleaks:latest git --report-format sarif --report-path gitleaks.sarif --redact .
```

## Handling valid test data

Do not suppress findings globally unless they are confirmed false positives. Prefer one of these in order:

1. Remove the secret-like sample.
2. Replace it with clearly fake non-matching data.
3. Add a narrow `gitleaks:allow` comment if appropriate.
4. Add a minimal `.gitleaks.toml` or `.gitleaksignore` entry only for reviewed exceptions.
