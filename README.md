# Payroll Application

A modern, feature-rich payroll management system built with **ASP.NET Core 8.0** Razor Pages, **Entity Framework Core**, and **MySQL**. This application streamlines employee management, payroll processing, and payment tracking with automatic calculations and a clean, intuitive interface.

## 📋 Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Usage Guide](#usage-guide)
- [Database Management](#database-management)
- [Docker Deployment](#docker-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Business Logic](#business-logic)
- [Development](#development)
- [Troubleshooting](#troubleshooting)

## ✨ Features

### Employee Management
- ➕ **Create, Read, Update, Delete (CRUD)** operations for employees
- 👥 Support for **Salaried** and **Hourly** employees
- 📧 Employee information: ID, Name, Email, Department, Hire Date
- 📊 Individual employee payroll history tracking
- 🔍 Unique employee ID validation

### Payroll Processing
- 💰 **Automated payroll calculations** with configurable pay periods
- 📅 Flexible pay period date selection
- ⏱️ Hours tracking for hourly employees
- 🧮 **Automatic deductions**:
  - Federal Tax: 15% of gross pay
  - Social Security: 6.2% of gross pay
  - Health Insurance: $200 (fixed monthly amount)
- 📈 Real-time net pay calculation
- 💳 Payment date tracking

### Payment History & Reporting
- 📜 Comprehensive payroll history
- 🔎 Filter by employee and date range
- 💵 Detailed breakdown of:
  - Gross Pay
  - Individual deductions (Tax, Social Security, Health Insurance)
  - Total deductions
  - Net pay
- 📊 Summary totals at bottom of history

### Dashboard & Analytics
- 📈 Employee count statistics
- 💼 Monthly payroll overview
- 🎯 Quick access to key features
- 📅 Recent payroll activity

### Data Management
- 🎲 **Automatic database creation** on first run
- 📦 **Sample data seeding** with 7 pre-configured employees
- 🗄️ Cascade delete: removing an employee removes their payroll history
- 🔐 Database connection string configuration

## 🛠️ Technology Stack

- **Framework**: ASP.NET Core 8.0
- **UI**: Razor Pages with Bootstrap
- **Database**: MySQL 8.0+
- **ORM**: Entity Framework Core 8.0
- **MySQL Provider**: Pomelo.EntityFrameworkCore.MySql 8.0
- **Language**: C# 12 (.NET 8)
- **Architecture**: Model-View-Controller pattern with Razor Pages
- **Dependency Injection**: Built-in ASP.NET Core DI
- **Containerization**: Docker support
- **CI/CD**: Azure DevOps Pipeline

## 📦 Prerequisites

### Required
- **[.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)** or later
- **MySQL Server 8.0+** (local or remote)
- **MySQL User** with database creation privileges

### Optional
- **Docker** (for containerized deployment)
- **Visual Studio 2022** or **VS Code** (for development)
- **Azure DevOps** (for CI/CD pipeline)

## 🚀 Getting Started

### 1. Install .NET SDK

Download and install the .NET 8 SDK from: https://dotnet.microsoft.com/download/dotnet/8.0

Verify installation:
```powershell
dotnet --version
# Should display: 8.0.xxx
```

### 2. Setup MySQL Database

**Option A: Local MySQL Installation**
- Install MySQL Server 8.0+ from [mysql.com](https://dev.mysql.com/downloads/)
- Create a database user:
```sql
CREATE USER 'payroll_app'@'localhost' IDENTIFIED BY 'PayrollApp@2026';
GRANT ALL PRIVILEGES ON PayrollDB.* TO 'payroll_app'@'localhost';
FLUSH PRIVILEGES;
```

**Option B: Use Existing MySQL Server**
- Update connection string in [appsettings.json](appsettings.json) with your credentials

### 3. Clone and Navigate to Project

```powershell
cd "c:\Db-migration\sample pay v2\sample-pay"
```

### 4. Restore NuGet Packages

```powershell
dotnet restore
```

### 5. Run the Application

```powershell
dotnet run
```

The application will:
1. ✅ Automatically create the database if it doesn't exist
2. ✅ Apply schema migrations
3. ✅ Seed sample data (7 employees)
4. ✅ Start the web server

**Expected output:**
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
```

### 6. Open in Browser

Navigate to: **https://localhost:5001** or **http://localhost:5000**

## ⚙️ Configuration

### Database Connection String

Edit [appsettings.json](appsettings.json):

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Port=3306;Database=PayrollDB;User=payroll_app;Password=PayrollApp@2026;"
  }
}
```

**Connection String Parameters:**
- `Server`: MySQL server hostname (default: `localhost`)
- `Port`: MySQL port (default: `3306`)
- `Database`: Database name (will be auto-created)
- `User`: MySQL username
- `Password`: MySQL password

### Payroll Calculation Constants

Deduction rates are defined in [PayrollCalculationService.cs](Services/PayrollCalculationService.cs):

```csharp
private const decimal TaxRate = 0.15m;                    // 15%
private const decimal SocialSecurityRate = 0.062m;        // 6.2%
private const decimal HealthInsuranceAmount = 200m;       // $200 fixed
```

To modify rates, edit these constants and rebuild the application.

## 📁 Project Structure

```
sample-pay/
├── 📄 Program.cs                          # Application entry point & configuration
├── 📄 PayrollApp.csproj                   # Project file with dependencies
├── 📄 appsettings.json                    # Configuration (connection strings, logging)
├── 📄 Dockerfile                          # Docker container configuration
├── 📄 azure-pipelines.yml                 # Azure DevOps CI/CD pipeline
├── 📄 README.md                           # This file
├── 📄 SETUP.md                            # Detailed setup guide
├── 📄 QUICKSTART.md                       # Quick reference guide
│
├── 📂 Data/                               # Database layer
│   ├── ApplicationDbContext.cs            # EF Core DbContext
│   └── DbInitializer.cs                   # Database seeding logic
│
├── 📂 Models/                             # Domain models (entities)
│   ├── Employee.cs                        # Employee entity
│   ├── PayrollRecord.cs                   # Payroll record entity
│   └── EmploymentType.cs                  # Enum: Salaried, Hourly
│
├── 📂 Services/                           # Business logic layer
│   └── PayrollCalculationService.cs       # Payroll calculation engine
│
├── 📂 Pages/                              # Razor Pages (Views + Controllers)
│   ├── Index.cshtml/.cs                   # Dashboard
│   ├── Error.cshtml/.cs                   # Error page
│   ├── _ViewImports.cshtml                # Global view imports
│   ├── _ViewStart.cshtml                  # Layout configuration
│   │
│   ├── 📂 Employees/                      # Employee management
│   │   ├── Index.cshtml/.cs               # List all employees
│   │   ├── Create.cshtml/.cs              # Add new employee
│   │   ├── Edit.cshtml/.cs                # Edit employee
│   │   ├── Details.cshtml/.cs             # View employee details
│   │   └── Delete.cshtml/.cs              # Delete employee
│   │
│   ├── 📂 Payroll/                        # Payroll operations
│   │   ├── Process.cshtml/.cs             # Process payroll
│   │   └── History.cshtml/.cs             # View payment history
│   │
│   └── 📂 Shared/                         # Shared layouts
│       ├── _Layout.cshtml                 # Main layout template
│       └── _ValidationScriptsPartial.cshtml
│
├── 📂 Properties/
│   └── launchSettings.json                # Development server configuration
│
└── 📂 wwwroot/                            # Static web assets
    ├── 📂 css/
    │   └── site.css                       # Custom styles
    └── 📂 js/
        └── site.js                        # Custom JavaScript
```

## 📖 Usage Guide

### Adding Employees

1. Click **"Employees"** in the navigation menu
2. Click **"Add New Employee"** button
3. Fill in the required fields:
   - **Employee ID**: Unique identifier (e.g., EMP001)
   - **Name**: Full name
   - **Email**: Valid email address
   - **Department**: Department name (optional)
   - **Employment Type**: Select "Salaried" or "Hourly"
   - **Annual Salary** (for salaried) OR **Hourly Rate** (for hourly)
   - **Hire Date**: Date of hire
4. Click **"Create Employee"**

**Example - Salaried Employee:**
- Employee ID: `EMP101`
- Name: `Alice Williams`
- Email: `alice.williams@company.com`
- Department: `Finance`
- Employment Type: `Salaried`
- Annual Salary: `$80,000`
- Hire Date: `2026-01-15`

**Example - Hourly Employee:**
- Employee ID: `EMP102`
- Name: `Bob Johnson`
- Email: `bob.johnson@company.com`
- Department: `Warehouse`
- Employment Type: `Hourly`
- Hourly Rate: `$28.50`
- Hire Date: `2026-02-01`

### Processing Payroll

1. Click **"Process Payroll"** in the navigation menu
2. **Select an employee** from the dropdown
3. **Set Pay Period**:
   - Pay Period Start Date
   - Pay Period End Date
4. **For Hourly Employees**: Enter hours worked (e.g., 160 hours)
5. Click **"Calculate Payroll"**
6. Review the calculation breakdown:
   - Gross Pay
   - Tax Deduction (15%)
   - Social Security (6.2%)
   - Health Insurance ($200)
   - **Net Pay** (amount employee receives)
7. Click **"Process Payment"** to save the record

**Calculation Example (Salaried - $75,000/year):**
```
Monthly Gross Pay:     $6,250.00
- Tax (15%):          -$  937.50
- Social Security:    -$  387.50
- Health Insurance:   -$  200.00
─────────────────────────────────
Total Deductions:      $1,525.00
Net Pay:               $4,725.00
```

**Calculation Example (Hourly - $30/hour × 160 hours):**
```
Gross Pay:             $4,800.00
- Tax (15%):          -$  720.00
- Social Security:    -$  297.60
- Health Insurance:   -$  200.00
─────────────────────────────────
Total Deductions:      $1,217.60
Net Pay:               $3,582.40
```

### Viewing Payment History

1. Click **"Payment History"** in the navigation menu
2. **Optional Filters**:
   - **Employee**: Select specific employee (or "All Employees")
   - **Date Range**: Set start and end dates
3. Click **"Apply Filter"**
4. View payroll records with:
   - Employee name
   - Pay period dates
   - Hours worked (if hourly)
   - Gross pay, deductions, net pay
   - Payment date
5. **Summary totals** appear at the bottom

### Managing Employees

**View Details:**
- Click **"Details"** next to an employee to see:
  - Complete employee information
  - Full payroll history for that employee

**Edit Employee:**
- Click **"Edit"** to update employee information
- Cannot change employment type after creation
- Changes take effect immediately

**Delete Employee:**
- Click **"Delete"** next to an employee
- ⚠️ **Warning**: This will also delete all payroll records for that employee
- Confirm deletion when prompted

## 🗄️ Database Management

### Automatic Database Setup

On first run, the application automatically:
1. ✅ Creates the `PayrollDB` database if it doesn't exist
2. ✅ Creates all required tables (`Employees`, `PayrollRecords`)
3. ✅ Seeds 7 sample employees

### Sample Data

The application includes these pre-configured employees:

| Employee ID | Name | Department | Type | Rate/Salary | Hire Date |
|-------------|------|------------|------|-------------|-----------|
| EMP001 | John Smith | Engineering | Salaried | $75,000/year | 2023-01-15 |
| EMP002 | Sarah Johnson | Human Resources | Salaried | $65,000/year | 2022-06-01 |
| EMP003 | Michael Brown | Sales | Salaried | $55,000/year | 2023-03-20 |
| EMP004 | Emily Davis | Operations | Hourly | $25.00/hour | 2024-01-10 |
| EMP005 | James Wilson | Operations | Hourly | $30.00/hour | 2023-08-15 |
| EMP006 | Lisa Anderson | Marketing | Salaried | $70,000/year | 2022-11-05 |
| EMP007 | David Martinez | IT Support | Hourly | $35.00/hour | 2024-02-01 |

### Entity Framework Core Migrations

**Create a new migration:**
```powershell
dotnet ef migrations add MigrationName
```

**Apply migrations to database:**
```powershell
dotnet ef database update
```

**Remove last migration:**
```powershell
dotnet ef migrations remove
```

**View migration SQL:**
```powershell
dotnet ef migrations script
```

### Database Schema

**Employees Table:**
- `Id` (PK, Auto-increment)
- `EmployeeId` (Unique, varchar(50))
- `Name` (varchar(100))
- `Email` (varchar(100))
- `Department` (varchar(100), nullable)
- `EmploymentType` (enum: 0=Salaried, 1=Hourly)
- `AnnualSalary` (decimal(18,2), nullable)
- `HourlyRate` (decimal(18,2), nullable)
- `HireDate` (date)

**PayrollRecords Table:**
- `Id` (PK, Auto-increment)
- `EmployeeId` (FK → Employees.Id, cascade delete)
- `PayPeriodStart` (date)
- `PayPeriodEnd` (date)
- `HoursWorked` (decimal(18,2), nullable)
- `GrossPay` (decimal(18,2))
- `TaxAmount` (decimal(18,2))
- `SocialSecurityAmount` (decimal(18,2))
- `HealthInsuranceAmount` (decimal(18,2))
- `TotalDeductions` (decimal(18,2))
- `NetPay` (decimal(18,2))
- `PaymentDate` (date)

## 🐳 Docker Deployment

### Build Docker Image

```powershell
docker build -t payroll-app:latest .
```

### Run with Docker

```powershell
docker run -d `
  -p 8080:80 `
  -e ConnectionStrings__DefaultConnection="Server=host.docker.internal;Port=3306;Database=PayrollDB;User=payroll_app;Password=PayrollApp@2026;" `
  --name payroll-app `
  payroll-app:latest
```

Access the application at: **http://localhost:8080**

### Docker Compose (Optional)

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: PayrollDB
      MYSQL_USER: payroll_app
      MYSQL_PASSWORD: PayrollApp@2026
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  app:
    build: .
    ports:
      - "8080:80"
    environment:
      ConnectionStrings__DefaultConnection: "Server=mysql;Port=3306;Database=PayrollDB;User=payroll_app;Password=PayrollApp@2026;"
    depends_on:
      - mysql

volumes:
  mysql_data:
```

Run with:
```powershell
docker-compose up -d
```

## 🔄 CI/CD Pipeline

The project includes an Azure DevOps pipeline ([azure-pipelines.yml](azure-pipelines.yml)) with three stages:

### 1. Build Stage
- Restores NuGet packages
- Compiles the application
- Publishes artifacts

### 2. Database Migration Stage
- Installs EF Core tools
- Applies database migrations to production

### 3. Deploy Stage
- Deploys to Azure App Service

**To use the pipeline:**
1. Create an Azure DevOps project
2. Set up a service connection to Azure
3. Configure pipeline variables:
   - `AzureSqlConnectionString`: Production database connection string
4. Push code to trigger the pipeline

## 🧮 Business Logic

### Payroll Calculation Service

The [PayrollCalculationService](Services/PayrollCalculationService.cs) handles all payroll calculations:

#### Methods:

**`CalculateGrossPay(Employee, hoursWorked?)`**
- Salaried: `AnnualSalary ÷ 12`
- Hourly: `HourlyRate × hoursWorked` (default: 160 hours)

**`CalculateTax(grossPay)`**
- Returns: `grossPay × 0.15` (15% tax rate)

**`CalculateSocialSecurity(grossPay)`**
- Returns: `grossPay × 0.062` (6.2% rate)

**`GetHealthInsuranceDeduction()`**
- Returns: `$200.00` (fixed monthly amount)

**`CalculateTotalDeductions(tax, socialSecurity, healthInsurance)`**
- Returns: Sum of all deductions

**`CalculateNetPay(grossPay, totalDeductions)`**
- Returns: `grossPay - totalDeductions`

**`ProcessPayroll(Employee, payPeriodStart, payPeriodEnd, hoursWorked?)`**
- Complete end-to-end payroll processing
- Returns: `PayrollRecord` object with all calculated values

### Validation Rules

**Employee:**
- Employee ID: Required, unique, max 50 characters
- Name: Required, max 100 characters
- Email: Required, valid email format, max 100 characters
- Department: Optional, max 100 characters
- Annual Salary: Must be ≥ 0 (for salaried employees)
- Hourly Rate: Must be ≥ 0 (for hourly employees)
- Hire Date: Required, valid date

**Payroll Record:**
- Hours Worked: 0 to 744 (31 days × 24 hours)
- All monetary values: 2 decimal places

## 🛠️ Development

### Common Commands

```powershell
# Run the application
dotnet run

# Run with hot reload (watches for file changes)
dotnet watch run

# Build the project
dotnet build

# Clean build artifacts
dotnet clean

# Restore NuGet packages
dotnet restore

# Run with custom URL
dotnet run --urls "http://localhost:5050"

# Publish for production
dotnet publish -c Release -o ./publish
```

### Development Environment Setup

**Visual Studio 2022:**
1. Open `PayrollApp.csproj`
2. Press F5 to run with debugging

**VS Code:**
1. Install C# Dev Kit extension
2. Open folder in VS Code
3. Press F5 to run with debugging

### Adding New Features

**1. Add a new model:**
- Create class in `Models/` folder
- Add DbSet to `ApplicationDbContext.cs`
- Create migration: `dotnet ef migrations add AddModelName`
- Update database: `dotnet ef database update`

**2. Add a new Razor Page:**
```powershell
dotnet new page --name PageName --namespace PayrollApp.Pages --output Pages/
```

**3. Add a new service:**
- Create class in `Services/` folder
- Register in `Program.cs`: `builder.Services.AddScoped<ServiceName>();`

## 🔧 Troubleshooting

### Issue: "Unable to connect to MySQL server"
**Solution:**
- Verify MySQL is running: `mysql -u root -p`
- Check connection string in `appsettings.json`
- Ensure firewall allows port 3306
- Verify user has correct permissions

### Issue: "Database 'PayrollDB' does not exist"
**Solution:**
- The app creates the database automatically on first run
- Ensure the MySQL user has CREATE DATABASE privilege:
```sql
GRANT CREATE ON *.* TO 'payroll_app'@'localhost';
```

### Issue: ".NET SDK not found"
**Solution:**
- Download and install from: https://dotnet.microsoft.com/download/dotnet/8.0
- Open a NEW terminal window after installation
- Verify: `dotnet --version`

### Issue: "Port 5001 already in use"
**Solution:**
```powershell
# Run on different port
dotnet run --urls "http://localhost:5050;https://localhost:5051"
```

### Issue: "Entity Framework tools not found"
**Solution:**
```powershell
dotnet tool install --global dotnet-ef --version 8.0.0
```

### Issue: Sample data not appearing
**Solution:**
- Delete the database and restart the app
- Or run the seeder manually:
```csharp
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    DbInitializer.Initialize(context);
}
```

## 📚 Additional Resources

- **[SETUP.md](SETUP.md)**: Detailed installation guide for beginners
- **[QUICKSTART.md](QUICKSTART.md)**: Quick reference for common tasks
- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core)
- [Entity Framework Core Documentation](https://docs.microsoft.com/ef/core)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Pomelo EF Core Provider](https://github.com/PomeloFoundation/Pomelo.EntityFrameworkCore.MySql)

## 📄 License

This project is provided as-is for educational and demonstration purposes.

## 👥 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

**Built with ❤️ using ASP.NET Core 8.0**

1. Navigate to **Process Payroll** from the menu
2. Select an employee from the dropdown
3. Set the pay period dates
4. For hourly employees, enter hours worked
5. Click **Calculate & Process Payroll**
6. Review the payroll summary showing gross pay, deductions, and net pay

### Viewing Payment History

1. Navigate to **Payment History** from the menu
2. Use filters to view specific records:
   - Filter by employee
   - Filter by date range
3. View summary totals at the bottom of the table

## Sample Data

The application includes 7 sample employees:
- 4 Salaried employees
- 3 Hourly employees

You can delete or modify these as needed.

## Database

The application uses SQLite with a file-based database (`payroll.db`). The database is created automatically in the project root folder.

To view/edit the database, you can use:
- [DB Browser for SQLite](https://sqlitebrowser.org/)
- [SQLite Browser VS Code Extension](https://marketplace.visualstudio.com/items?itemName=alexcvzz.vscode-sqlite)

## Technologies Used

- **ASP.NET Core 8.0** - Web framework
- **Razor Pages** - UI framework
- **Entity Framework Core 8.0** - ORM
- **SQLite** - Database
- **Bootstrap 5** - CSS framework

## Troubleshooting

### Database Issues

If you encounter database errors, try deleting `payroll.db` and running the application again to recreate it.

### Port Conflicts

If ports 5000/5001 are in use, you can specify a different port:

```powershell
dotnet run --urls "http://localhost:5050;https://localhost:5051"
```

## Future Enhancements

- User authentication and authorization
- Multiple pay frequencies (weekly, bi-weekly, monthly)
- Time tracking for hourly employees
- Advanced tax calculations
- Export to PDF/Excel
- Email notifications
- Employee self-service portal

## License

This is a sample application for educational purposes.
