# Payroll Application

A simple payroll management system built with ASP.NET Core Razor Pages, Entity Framework Core, and SQLite.

## Features

- **Employee Management**: Add, edit, view, and delete employees
- **Employment Types**: Support for both salaried and hourly employees
- **Payroll Processing**: Calculate payroll with automatic deductions
  - Tax: 15%
  - Social Security: 6.2%
  - Health Insurance: $200 (fixed)
- **Payment History**: View and filter payroll records
- **Dashboard**: Overview of employees and payroll statistics

## Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) or later

## Getting Started

### 1. Install .NET SDK

Download and install the .NET SDK from: https://dotnet.microsoft.com/download

After installation, verify by running:
```powershell
dotnet --version
```

### 2. Restore NuGet Packages

```powershell
cd "c:\Db-migration\payroll sample pj"
dotnet restore
```

### 3. Create the Database

The application uses SQLite, which requires no installation. The database will be created automatically on first run.

To manually create the database and apply migrations:

```powershell
dotnet ef migrations add InitialCreate
dotnet ef database update
```

### 4. Run the Application

```powershell
dotnet run
```

The application will start and display the URL (typically https://localhost:5001 or http://localhost:5000).

Open your browser and navigate to the displayed URL.

## Project Structure

```
PayrollApp/
├── Data/                          # Database context and seeder
│   ├── ApplicationDbContext.cs
│   └── DbInitializer.cs
├── Models/                        # Domain models
│   ├── Employee.cs
│   ├── PayrollRecord.cs
│   └── EmploymentType.cs
├── Services/                      # Business logic
│   └── PayrollCalculationService.cs
├── Pages/                         # Razor Pages
│   ├── Index.cshtml              # Dashboard
│   ├── Employees/                # Employee management pages
│   │   ├── Index.cshtml
│   │   ├── Create.cshtml
│   │   ├── Edit.cshtml
│   │   ├── Details.cshtml
│   │   └── Delete.cshtml
│   ├── Payroll/                  # Payroll pages
│   │   ├── Process.cshtml
│   │   └── History.cshtml
│   └── Shared/                   # Shared layout
│       └── _Layout.cshtml
├── wwwroot/                      # Static files
│   ├── css/
│   └── js/
└── payroll.db                    # SQLite database (created on first run)
```

## Usage

### Adding Employees

1. Navigate to **Employees** from the menu
2. Click **Add New Employee**
3. Fill in the employee details:
   - Employee ID (unique identifier)
   - Name, Email, Department
   - Employment Type (Salaried or Hourly)
   - Salary or Hourly Rate
   - Hire Date
4. Click **Create Employee**

### Processing Payroll

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
