# Quick Start Guide

## For Users Without .NET Installed

### 1. Install .NET SDK (One-time setup)
```powershell
# Visit and download .NET 8 SDK:
# https://dotnet.microsoft.com/download/dotnet/8.0

# After installation, verify (in a NEW terminal):
dotnet --version
```

### 2. Run the Application
```powershell
cd "c:\Db-migration\payroll sample pj"
dotnet run
```

### 3. Open Your Browser
Navigate to: **https://localhost:5001**

---

## For Users With .NET Already Installed

### Run the Application
```powershell
cd "c:\Db-migration\payroll sample pj"
dotnet run
```

Open browser: **https://localhost:5001**

---

## Common Commands

```powershell
# Run the application
dotnet run

# Build the application (check for errors)
dotnet build

# Restore packages
dotnet restore

# Clean build artifacts
dotnet clean

# Run with custom port
dotnet run --urls "http://localhost:5050"

# Create database migrations (if needed)
dotnet ef migrations add MigrationName
dotnet ef database update
```

---

## Application Features

### Dashboard (Home Page)
- View employee count statistics
- See monthly payroll summary
- Quick action buttons
- Recent payroll activity

### Employees Management
- **View All**: List all employees with details
- **Add New**: Create new employee record
- **Edit**: Update employee information
- **Delete**: Remove employee (with payroll history)
- **Details**: View employee info and payroll history

### Process Payroll
- Select employee
- Set pay period dates
- Enter hours for hourly employees
- Automatic calculation of:
  - Gross pay
  - Tax (15%)
  - Social Security (6.2%)
  - Health Insurance ($200)
  - Net pay

### Payment History
- View all payroll records
- Filter by employee
- Filter by date range
- See totals at the bottom

---

## Quick Test Workflow

1. **Start the app**: `dotnet run`
2. **Open browser**: https://localhost:5001
3. **View employees**: Click "Employees" - see 7 sample employees
4. **Process payroll**:
   - Click "Process Payroll"
   - Select "John Smith" (salaried)
   - Keep default dates
   - Click "Calculate & Process Payroll"
   - See the calculated net pay
5. **Check history**: Click "Payment History" - see the record you just created

---

## Sample Employees Included

1. **John Smith** - Salaried, $75,000/year, Engineering
2. **Sarah Johnson** - Salaried, $65,000/year, HR
3. **Michael Brown** - Salaried, $55,000/year, Sales
4. **Emily Davis** - Hourly, $25/hour, Operations
5. **James Wilson** - Hourly, $30/hour, Operations
6. **Lisa Anderson** - Salaried, $70,000/year, Marketing
7. **David Martinez** - Hourly, $35/hour, IT Support

---

## Stopping the Application

Press **Ctrl+C** in the terminal

---

## Need Help?

- **Detailed setup**: See SETUP.md
- **Full documentation**: See README.md
- **No .NET SDK**: Follow SETUP.md Step 1
