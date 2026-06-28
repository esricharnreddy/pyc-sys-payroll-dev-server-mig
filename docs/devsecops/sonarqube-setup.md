# SonarQube Community Edition Setup

## Purpose

SonarQube provides automated code quality and static analysis for the payroll application pipeline.

## Prerequisites

- Running self-hosted SonarQube Community Edition server.
- Project created in SonarQube for this repository.
- A generated SonarQube token with permission to analyze the project.

## GitHub secrets

Create these repository secrets:

- `SONAR_HOST_URL`
- `SONAR_TOKEN`

Do not store these values in workflow files or source code.

## GitHub Actions behavior

The workflow uses `dotnet-sonarscanner` and waits for the quality gate result.

Analysis sequence:

1. `dotnet restore`
2. Sonar `begin`
3. `dotnet build`
4. `dotnet test`
5. Sonar `end`
6. Quality gate wait

## Community Edition limitation

Community Edition supports main or integration branch analysis, but not full PR analysis or multi-branch analysis in the same way as paid editions. For this repository, the workflow runs SonarQube analysis on `dev` pushes.

## Local usage

Install the scanner locally if needed:

```powershell
dotnet tool install --global dotnet-sonarscanner
```

Example local flow:

```powershell
dotnet sonarscanner begin /k:"pyc-sys-payroll-dev-server-mig" /d:sonar.host.url="<SONAR_HOST_URL>" /d:sonar.token="<SONAR_TOKEN>"
dotnet build PayrollApp.Tests/PayrollApp.Tests.csproj
dotnet test PayrollApp.Tests/PayrollApp.Tests.csproj
dotnet sonarscanner end /d:sonar.token="<SONAR_TOKEN>"
```

## Troubleshooting

- If analysis fails immediately, verify `SONAR_HOST_URL` and `SONAR_TOKEN`.
- If the quality gate blocks the pipeline, review the project dashboard in SonarQube.
- If blame or SCM warnings appear, ensure checkout uses full history.
- If the scanner cannot connect over TLS, install the required trust chain on the runner or configure the required Sonar root certificate settings.
