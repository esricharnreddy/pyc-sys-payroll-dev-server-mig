# Payroll Application

A payroll management application built with ASP.NET Core 8 Razor Pages, Entity Framework Core, and Azure SQL Database. The app supports employee management, payroll processing, payment history, sample data seeding, Docker packaging, and optional Azure/Kubernetes deployment assets.

## Features

### Employee Management

- Create, read, update, and delete employee records.
- Support salaried and hourly employees.
- Store employee ID, name, email, department, employment type, salary/rate, and hire date.
- Enforce unique employee IDs.
- Cascade-delete payroll history when an employee is removed.

### Payroll Processing

- Process payroll for a selected employee and pay period.
- Calculate monthly gross pay for salaried employees.
- Calculate hourly gross pay from hourly rate and hours worked.
- Apply fixed deduction rules:
  - Federal tax: 15% of gross pay
  - Social Security: 6.2% of gross pay
  - Health insurance: $200 fixed deduction
- Save payroll records with gross pay, deductions, net pay, and payment date.

### Reporting

- Dashboard employee and payroll summaries.
- Recent payroll activity.
- Payment history with employee and date filters.
- Payroll totals for filtered history results.

## Technology Stack

- ASP.NET Core 8.0
- Razor Pages
- Entity Framework Core 8.0
- Microsoft SQL Server provider for EF Core
- Azure SQL Database
- Bootstrap 5
- Docker
- Terraform and Kubernetes manifests for Azure deployment scenarios
- GitHub Actions workflow for environment deployments

## Prerequisites

### Required

- .NET 8 SDK or later
- Access to SQL Server LocalDB for local development, or an Azure SQL Database connection string

### Optional

- Docker
- Visual Studio 2022 or VS Code with C# Dev Kit
- Terraform CLI for infrastructure changes
- Azure CLI and kubectl for Azure/Kubernetes deployment

## Getting Started

### 1. Install .NET 8 SDK

Download and install the .NET 8 SDK from:

https://dotnet.microsoft.com/download/dotnet/8.0

Verify installation:

```powershell
dotnet --version
```

### 2. Configure the Database

For local development, the default connection string uses SQL Server LocalDB:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=PayrollDB;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True;"
  }
}
```

For Azure SQL Database, set `ConnectionStrings__DefaultConnection` in your environment, container, Kubernetes Secret, or hosting platform configuration:

```powershell
$env:ConnectionStrings__DefaultConnection = "Server=tcp:<sql-server-name>.database.windows.net,1433;Initial Catalog=PayrollDB;User ID=<sql-admin-user>;Password=<sql-admin-password>;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
```

Use confirmed Azure resource names and secrets from your environment. Do not commit real credentials to the repository.

### 3. Restore Packages

```powershell
dotnet restore
```

### 4. Run the Application

```powershell
dotnet run
```

The application will:

- Create the schema in the configured database if needed.
- Seed 7 sample employees when the employee table is empty.
- Start the web server.

Open the URL shown in the terminal, commonly `https://localhost:5001` or `http://localhost:5000`.

## Project Structure

```text
pyc-sys-payroll-dev-server-mig/
|-- Program.cs                         # Application startup and service configuration
|-- PayrollApp.csproj                  # .NET project and package references
|-- appsettings.json                   # Local configuration and default connection string
|-- Dockerfile                         # Container build definition
|-- global.json                        # .NET SDK version policy
|-- QUICKSTART.md                      # Quick run guide
|-- SETUP.md                           # Setup notes
|-- Data/                              # EF Core DbContext and seeding
|-- Models/                            # Employee and payroll entities
|-- Services/                          # Payroll calculation service
|-- Pages/                             # Razor Pages UI
|-- Properties/                        # Launch settings
|-- wwwroot/                           # Static CSS and JavaScript
|-- infra/terraform/                   # Azure infrastructure definitions
|-- k8s/                               # Kubernetes manifests
`-- .github/workflows/                 # GitHub Actions deployment workflow
```

## Configuration

### Database Connection

The app reads the `DefaultConnection` connection string from ASP.NET Core configuration.

Local default in `appsettings.json`:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=PayrollDB;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True;"
}
```

Production or containerized deployments should override this value with `ConnectionStrings__DefaultConnection`.

Azure SQL format:

```text
Server=tcp:<sql-server-name>.database.windows.net,1433;Initial Catalog=PayrollDB;User ID=<sql-admin-user>;Password=<sql-admin-password>;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

### Payroll Calculation Constants

Deduction constants are defined in `Services/PayrollCalculationService.cs`:

```csharp
private const decimal TaxRate = 0.15m;
private const decimal SocialSecurityRate = 0.062m;
private const decimal HealthInsuranceAmount = 200m;
```

## Database Management

On startup, `Data/DbInitializer.cs` calls `EnsureCreated()` and seeds sample employees when no employees exist. This is simple and convenient for development or demo environments.

There is currently no `Migrations/` folder in this repository. If you want migration-based database lifecycle management, create an initial migration and switch operational processes to `dotnet ef database update`.

Common EF commands:

```powershell
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet ef migrations script
```

## Sample Data

The app seeds these employees on first run when the database is empty:

| Employee ID | Name | Department | Type | Rate/Salary | Hire Date |
|-------------|------|------------|------|-------------|-----------|
| EMP001 | John Smith | Engineering | Salaried | $75,000/year | 2023-01-15 |
| EMP002 | Sarah Johnson | Human Resources | Salaried | $65,000/year | 2022-06-01 |
| EMP003 | Michael Brown | Sales | Salaried | $55,000/year | 2023-03-20 |
| EMP004 | Emily Davis | Operations | Hourly | $25.00/hour | 2024-01-10 |
| EMP005 | James Wilson | Operations | Hourly | $30.00/hour | 2023-08-15 |
| EMP006 | Lisa Anderson | Marketing | Salaried | $70,000/year | 2022-11-05 |
| EMP007 | David Martinez | IT Support | Hourly | $35.00/hour | 2024-02-01 |

## Docker

Build the image:

```powershell
docker build -t payroll-app:latest .
```

Run with an Azure SQL Database connection string:

```powershell
docker run -d `
  -p 8080:80 `
  -e ConnectionStrings__DefaultConnection="Server=tcp:<sql-server-name>.database.windows.net,1433;Initial Catalog=PayrollDB;User ID=<sql-admin-user>;Password=<sql-admin-password>;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" `
  --name payroll-app `
  payroll-app:latest
```

Open `http://localhost:8080`.

## Azure Deployment Assets

Available Azure deployment assets are:

- `infra/terraform/`: provisions or references Azure resources such as resource group, Azure Container Registry, Azure SQL Database, and AKS integration.
- `k8s/`: Kubernetes namespace, service, deployment, and example secret manifests.
- `.github/workflows/infra.yml`: GitHub Actions workflow for Terraform infrastructure validation, planning, and apply.
- `.github/workflows/app-cicd.yml`: GitHub Actions workflow for app build, image push, and AKS deployment.

### GitHub Actions Pipelines

This repository uses two separate GitHub Actions pipelines:

1. `Infrastructure`
2. `App code build pipeline`

The old combined deployment workflow and Azure DevOps pipeline are not used.

### Infrastructure Pipeline

Workflow file: `.github/workflows/infra.yml`

Purpose: create or update Azure infrastructure using Terraform. This pipeline is responsible for resource group, ACR, Azure SQL Database, AKS integration, and ACR pull permissions.

Triggers:

- Push to `dev` when Terraform or the infra workflow changes (runs the full sequential chain).
- Pull request to `dev` when Terraform or the infra workflow changes (runs `Validate Terraform` only).
- Manual `workflow_dispatch` with an `apply` input.

This pipeline is intended to run first. When it completes successfully on `dev`, it automatically starts the App Code Build Pipeline (see that section).

Stage flow:

```text
Validate Terraform
  -> dev Infrastructure
    -> qa Infrastructure
      -> uat Infrastructure
        -> prod Infrastructure
```

Stage details:

- `Validate Terraform`: runs `terraform fmt`, `terraform init -backend=false`, and `terraform validate`.
- `dev Infrastructure`: initializes backend, plans, applies, and publishes outputs for `dev`.
- `qa Infrastructure`: initializes backend, plans, applies, and publishes outputs for `qa`.
- `uat Infrastructure`: initializes backend, plans, applies, and publishes outputs for `uat`.
- `prod Infrastructure`: initializes backend, plans, applies, and publishes outputs for `prod`.

When `CONFIGURE_AKS=true` and `GRANT_AKS_ACR_PULL=true`, each environment job checks whether the AKS kubelet identity already has `AcrPull` on the target ACR. If the role assignment exists but is not yet in Terraform state, the workflow imports it before `terraform plan`. This prevents `RoleAssignmentExists` failures when the permission was previously granted outside the current Terraform state.

The chain is strictly sequential so shared infrastructure is created in order. `dev` creates the shared ACR (`CREATE_ACR=true`); `qa` and `uat` reuse the dev ACR (`CREATE_ACR=false`, with `ACR_NAME`/`ACR_RESOURCE_GROUP_NAME` pointing at the dev ACR); `prod` creates its own ACR (`CREATE_ACR=true`). Because `dev` runs first, the shared ACR exists before `qa`/`uat` plan.

For pull requests, only `Validate Terraform` runs. On a manual run the pipeline walks the full chain `dev -> qa -> uat -> prod`, and each environment job starts only after the previous environment job succeeds. The `apply` input controls whether Terraform changes are applied. Production will not start unless `dev`, `qa`, and `uat` all succeed.

### App Code Build Pipeline

Workflow file: `.github/workflows/app-cicd.yml`

Purpose: build the app, create the Docker image, push the image to ACR, deploy to AKS, and confirm that the running app can connect to the database.

Triggers:

- Automatically after the `Infrastructure` workflow completes successfully on `dev` (`workflow_run`). This is the normal infra-then-app handoff.
- Push to `dev` when application, Docker, Kubernetes, or app workflow files change. This lets app-only changes deploy without re-running the infra pipeline.
- Pull request to `dev` when application, Docker, Kubernetes, or app workflow files change (build validation only).
- Manual `workflow_dispatch` (no inputs).

The `workflow_run` handoff only fires when this workflow file exists on the repository's **default branch**. If your default branch is not `dev`, set the default branch to `dev` (or keep the workflows on the default branch) so the chaining activates. For `workflow_run` runs the pipeline checks out and tags the image with the commit that triggered the infra run (`workflow_run.head_sha`), not the default-branch HEAD.

Stage flow:

```text
Build app code (create the Docker image)
  -> Deploy to dev
    -> Deploy to qa
      -> Deploy to uat
        -> Deploy to prod
```

Stage details:

- `Build app code (create the Docker image)`: restores dependencies, builds the .NET app, runs tests if test projects exist, builds the Docker image once, and stores it as a short-lived artifact shared by every environment.
- `Deploy to dev/qa/uat/prod`: each environment job downloads the shared image artifact, resolves the target ACR and repository from that environment's GitHub variables, tags the image with the commit SHA and `latest`, pushes both tags, gets AKS credentials, creates or updates the `payroll-db` Kubernetes Secret for Azure SQL, applies the namespace/service/deployment manifests into the environment namespace, waits for rollout, and confirms pods become Ready (which verifies AKS-to-database connectivity through the readiness probe).

The application is deployed to all four environments one after another. Each environment job starts only after the previous environment job succeeds, so the order is always `dev -> qa -> uat -> prod`.

For pull requests, the app pipeline validates the build and Docker image creation but does not push to ACR or deploy to AKS.

### Required GitHub Environments

Create these GitHub environments and configure environment protection rules as needed:

- `dev`
- `qa`
- `uat`
- `prod`

Recommended protection: require manual approval for `uat` and `prod` before infrastructure changes or app deployments continue.

### Required GitHub Variables and Secrets

Configure these values per GitHub environment. Use confirmed Azure resource names and do not commit secrets to the repository.

Infrastructure workflow variables and secrets:

```text
AZURE_CLIENT_ID                 secret
AZURE_TENANT_ID                 secret
AZURE_SUBSCRIPTION_ID           secret
TF_STATE_RESOURCE_GROUP         variable
TF_STATE_STORAGE_ACCOUNT        variable
TF_STATE_CONTAINER              variable
TF_STATE_KEY                    variable
AZURE_LOCATION                  variable
RESOURCE_GROUP_NAME             variable
CREATE_RESOURCE_GROUP           variable
ACR_NAME                        variable
ACR_RESOURCE_GROUP_NAME         variable
CREATE_ACR                      variable
CREATE_SQL                      variable
SQL_SERVER_NAME                 variable
SQL_LOCATION                    variable
SQL_ADMIN_USERNAME              variable
SQL_ADMIN_PASSWORD              secret
CONFIGURE_AKS                   variable
AKS_CLUSTER_NAME                variable
AKS_RESOURCE_GROUP              variable
GRANT_AKS_ACR_PULL              variable
```

App workflow variables and secrets:

```text
AZURE_CLIENT_ID                 secret
AZURE_TENANT_ID                 secret
AZURE_SUBSCRIPTION_ID           secret
ACR_NAME                        variable
IMAGE_REPOSITORY                variable
CONFIGURE_AKS                   variable
AKS_CLUSTER_NAME                variable
AKS_RESOURCE_GROUP              variable
K8S_NAMESPACE                   variable
SQL_SERVER_NAME                 variable
SQL_ADMIN_USERNAME              variable
SQL_ADMIN_PASSWORD              secret
```

Typical app image repository values are environment-specific, for example `payroll-dev`, `payroll-qa`, `payroll-uat`, and `payroll-prd`.

For Kubernetes deployments, create the database connection string as a Kubernetes Secret rather than committing it:

```powershell
kubectl create secret generic payroll-db `
  --namespace <namespace> `
  --from-literal=connection-string="Server=tcp:<sql-server-name>.database.windows.net,1433;Initial Catalog=PayrollDB;User ID=<sql-admin-user>;Password=<sql-admin-password>;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" `
  --dry-run=client -o yaml | kubectl apply -f -
```

## Common Commands

```powershell
dotnet restore
dotnet build
dotnet run
dotnet watch run
dotnet clean
dotnet publish -c Release -o ./publish
```

Run on custom ports:

```powershell
dotnet run --urls "http://localhost:5050;https://localhost:5051"
```

## Troubleshooting

### .NET SDK not found

Install the .NET 8 SDK, open a new terminal, and verify:

```powershell
dotnet --version
```

### Cannot connect to Azure SQL Database

- Confirm the connection string is set in the correct environment.
- Confirm the SQL server firewall allows the client or Azure service path.
- Confirm the SQL admin/user credentials are valid.
- Confirm `Encrypt=True` is present for Azure SQL connections.

### Database schema is missing

The app creates the schema with `EnsureCreated()` when it starts. Confirm the configured SQL user has permission to create tables in the target database.

### Entity Framework tools not found

```powershell
dotnet tool install --global dotnet-ef --version 8.0.0
```

## Additional Resources

- `SETUP.md`: Detailed setup guide
- `QUICKSTART.md`: Quick command reference
- ASP.NET Core documentation: https://docs.microsoft.com/aspnet/core
- Entity Framework Core documentation: https://docs.microsoft.com/ef/core
- Azure SQL Database documentation: https://learn.microsoft.com/azure/azure-sql/database/


