# Prompt for Copilot on Test PC

This is an ASP.NET Core 8.0 Razor Pages payroll application with newly added Phase 1 DevSecOps implementation.

## PROJECT CONTEXT
- Framework: ASP.NET Core 8.0
- Database: Entity Framework Core 8.0 with SQL Server LocalDB
- Application: Payroll management system (Employees, PayrollRecords, EmploymentTypes)
- Repository: https://github.com/esricharnreddy/test-sonar.git (dev branch)

## PHASE 1 DEVSECOPS CHANGES
1. Gitleaks integration for secret scanning (GitHub Actions workflow)
2. SonarQube Community Edition for code quality analysis (self-hosted)
3. Minimal xUnit test project (PayrollApp.Tests/) with 7 unit tests
4. Workflow refactored in .github/workflows/app-cicd.yml with two new quality gate jobs

## INTERNAL VALIDATION NEEDED
1. Verify all NuGet dependencies resolve correctly
2. Run unit tests successfully (PayrollApp.Tests project)
3. Check that the main application builds without errors
4. Validate test coverage and execution

Please help me validate this implementation locally before pushing to GitHub Actions CI.

---

## Step-by-Step Validation Checklist

### 1. Project Setup
```powershell
git clone https://github.com/esricharnreddy/test-sonar.git
cd test-sonar
git checkout dev

Get-ChildItem -Recurse PayrollApp.Tests
Get-ChildItem -Recurse docs/devsecops
```

### 2. Restore Dependencies
```powershell
dotnet restore PayrollApp.csproj
dotnet restore PayrollApp.Tests/PayrollApp.Tests.csproj
```
**Expected:** Clean restore with no dependency conflicts.

### 3. Build Main Application
```powershell
dotnet build PayrollApp.csproj -c Release
```
**Expected:** Build succeeds with no errors.

### 4. Build Test Project
```powershell
dotnet build PayrollApp.Tests/PayrollApp.Tests.csproj -c Release
```
**Expected:** Test project compiles successfully.

### 5. Run Unit Tests
```powershell
dotnet test PayrollApp.Tests/PayrollApp.Tests.csproj -c Release -v normal
```
**Expected output:**
- 7 tests discovered and executed
- All tests pass
- Total: 7 passing tests

### 6. Run Tests with Coverage
```powershell
dotnet test PayrollApp.Tests/PayrollApp.Tests.csproj -c Release --collect:"XPlat Code Coverage"
```
**Expected:** Coverage report generated in `PayrollApp.Tests/TestResults`.

### 7. Verify Workflow File Syntax
```powershell
Get-Content .github/workflows/app-cicd.yml -Raw | Measure-Object -Line
```
**Expected:** File exists and loads without errors.

### 8. Validate Payroll Calculation Logic
Open `Services/PayrollCalculationService.cs` and verify these methods exist:
- `CalculateGrossPay()`
- `CalculateTax()`
- `CalculateSocialSecurity()`
- `CalculateTotalDeductions()`
- `CalculateNetPay()`
- `ProcessPayroll()`

---

## Success Criteria (All Must Pass ✅)

- [ ] `dotnet restore` completes without errors
- [ ] `dotnet build PayrollApp.csproj` succeeds
- [ ] `dotnet build PayrollApp.Tests/PayrollApp.Tests.csproj` succeeds
- [ ] `dotnet test` shows **7 tests passing**
- [ ] Coverage report generates successfully
- [ ] Workflow file loads without syntax errors
- [ ] Both quality gate jobs are present in the workflow
- [ ] Test project has zero external dependencies (pure logic tests)

---

## Troubleshooting

**Problem:** Tests fail to compile
- **Solution:** Ensure xUnit using statement is present: `using Xunit;`
- **Check:** `PayrollApp.Tests/PayrollCalculationServiceTests.cs` line 1-5

**Problem:** NuGet packages fail to restore
- **Solution:** Clear local cache and retry
  ```powershell
  dotnet nuget locals all --clear
  dotnet restore PayrollApp.Tests/PayrollApp.Tests.csproj
  ```

**Problem:** Build errors in PayrollApp.csproj
- **Solution:** Verify that PayrollApp.csproj does NOT include test files
- **Check:** `<ItemGroup>` sections should not reference `PayrollApp.Tests/**`

**Problem:** Coverage report not generated
- **Solution:** Ensure coverlet.collector is installed
  ```powershell
  dotnet add PayrollApp.Tests/PayrollApp.Tests.csproj package coverlet.collector
  ```

---

Once all checks pass, proceed to [VALIDATION_REPORT.md](VALIDATION_REPORT.md) to document results.
