# Setup Guide for Payroll Application

This guide will help you install .NET and run the Payroll Application for the first time.

## Step 1: Install .NET 8 SDK

### Windows Installation

1. **Download .NET 8 SDK**
   - Visit: https://dotnet.microsoft.com/download/dotnet/8.0
   - Click on "Download .NET SDK x64" for Windows
   - Run the downloaded installer (e.g., `dotnet-sdk-8.0.xxx-win-x64.exe`)

2. **Follow the installation wizard**
   - Accept the license terms
   - Choose the default installation location
   - Wait for the installation to complete

3. **Verify the installation**
   - Open a new PowerShell or Command Prompt window
   - Run: `dotnet --version`
   - You should see the version number (e.g., `8.0.100`)

   **Important:** You must open a NEW terminal window after installation!

## Step 2: Navigate to the Project Folder

```powershell
cd "c:\Db-migration\payroll sample pj"
```

## Step 3: Restore NuGet Packages

This downloads all required libraries:

```powershell
dotnet restore
```

You should see output indicating packages are being downloaded.

## Step 4: Build the Project

```powershell
dotnet build
```

This compiles the application and checks for errors.

## Step 5: Run the Application

```powershell
dotnet run
```

You should see output similar to:
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

## Step 6: Open in Your Browser

Open your web browser and navigate to:
- **https://localhost:5001** (secure) or
- **http://localhost:5000** (non-secure)

The Payroll Application dashboard should appear!

## What You Should See

1. **Dashboard** with statistics (0 employees initially, then sample data after first run)
2. **Navigation menu** with:
   - Dashboard
   - Employees
   - Process Payroll
   - Payment History

## Sample Data

The application automatically creates 7 sample employees on first run:
- John Smith (Salaried - $75,000/year)
- Sarah Johnson (Salaried - $65,000/year)
- Michael Brown (Salaried - $55,000/year)
- Emily Davis (Hourly - $25/hour)
- James Wilson (Hourly - $30/hour)
- Lisa Anderson (Salaried - $70,000/year)
- David Martinez (Hourly - $35/hour)

## Stopping the Application

Press `Ctrl+C` in the terminal window where the application is running.

## Troubleshooting

### Problem: "dotnet is not recognized"

**Solution:** 
- Restart your computer after installing .NET SDK
- Or close all terminal windows and open a new one
- Make sure you installed the SDK, not just the Runtime

### Problem: Port 5000/5001 already in use

**Solution:** Run with a different port:
```powershell
dotnet run --urls "http://localhost:5050;https://localhost:5051"
```
Then open `http://localhost:5050` in your browser.

### Problem: Database errors

**Solution:** Delete the `payroll.db` file and run the app again:
```powershell
Remove-Item payroll.db -ErrorAction SilentlyContinue
dotnet run
```

### Problem: Build errors

**Solution:** Clean and rebuild:
```powershell
dotnet clean
dotnet restore
dotnet build
```

## Next Steps

Once the application is running:

1. **View Employees**
   - Click "Employees" in the navigation
   - Browse the pre-populated sample employees

2. **Process Your First Payroll**
   - Click "Process Payroll"
   - Select an employee
   - Set the pay period dates
   - For hourly employees, enter hours worked (e.g., 160)
   - Click "Calculate & Process Payroll"

3. **View Payment History**
   - Click "Payment History"
   - See all processed payroll records
   - Use filters to search by employee or date

4. **Add Your Own Employee**
   - Go to Employees → "Add New Employee"
   - Fill in the details
   - Choose Salaried or Hourly
   - Save

## Database Location

The SQLite database (`payroll.db`) is created in the project root folder:
```
c:\Db-migration\payroll sample pj\payroll.db
```

You can open this file with:
- [DB Browser for SQLite](https://sqlitebrowser.org/) (free tool)
- Or any SQLite database viewer

## Development Mode

The application runs in Development mode by default, which provides:
- Detailed error messages
- Database query logging
- Hot reload (automatic restart on file changes)

## Additional Resources

- **ASP.NET Core Documentation:** https://docs.microsoft.com/aspnet/core/
- **Entity Framework Core:** https://docs.microsoft.com/ef/core/
- **C# Documentation:** https://docs.microsoft.com/dotnet/csharp/

## Support

If you encounter issues not covered here:
1. Check the error message in the terminal
2. Review the README.md file
3. Make sure .NET 8 SDK is properly installed
4. Try restarting your computer

Happy payroll processing! 🎉
