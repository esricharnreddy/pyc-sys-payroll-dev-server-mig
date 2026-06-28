using Microsoft.EntityFrameworkCore;
using PayrollApp.Models;

namespace PayrollApp.Data;

public static class DbInitializer
{
    public static void Initialize(ApplicationDbContext context)
    {
        // The Azure SQL Database is provisioned by infrastructure (Terraform).
        // EnsureCreated() creates the schema inside that existing database.
        context.Database.EnsureCreated();

        // Check if we already have data
        if (context.Employees.Any())
        {
            return; // DB has been seeded
        }

        // Seed Employees
        var employees = new Employee[]
        {
            new Employee
            {
                EmployeeId = "EMP001",
                Name = "John Smith",
                Email = "john.smith@company.com",
                Department = "Engineering",
                EmploymentType = EmploymentType.Salaried,
                AnnualSalary = 75000m,
                HireDate = new DateTime(2023, 1, 15)
            },
            new Employee
            {
                EmployeeId = "EMP002",
                Name = "Sarah Johnson",
                Email = "sarah.johnson@company.com",
                Department = "Human Resources",
                EmploymentType = EmploymentType.Salaried,
                AnnualSalary = 65000m,
                HireDate = new DateTime(2022, 6, 1)
            },
            new Employee
            {
                EmployeeId = "EMP003",
                Name = "Michael Brown",
                Email = "michael.brown@company.com",
                Department = "Sales",
                EmploymentType = EmploymentType.Salaried,
                AnnualSalary = 55000m,
                HireDate = new DateTime(2023, 3, 20)
            },
            new Employee
            {
                EmployeeId = "EMP004",
                Name = "Emily Davis",
                Email = "emily.davis@company.com",
                Department = "Operations",
                EmploymentType = EmploymentType.Hourly,
                HourlyRate = 25.00m,
                HireDate = new DateTime(2024, 1, 10)
            },
            new Employee
            {
                EmployeeId = "EMP005",
                Name = "James Wilson",
                Email = "james.wilson@company.com",
                Department = "Operations",
                EmploymentType = EmploymentType.Hourly,
                HourlyRate = 30.00m,
                HireDate = new DateTime(2023, 8, 15)
            },
            new Employee
            {
                EmployeeId = "EMP006",
                Name = "Lisa Anderson",
                Email = "lisa.anderson@company.com",
                Department = "Marketing",
                EmploymentType = EmploymentType.Salaried,
                AnnualSalary = 70000m,
                HireDate = new DateTime(2022, 11, 5)
            },
            new Employee
            {
                EmployeeId = "EMP007",
                Name = "David Martinez",
                Email = "david.martinez@company.com",
                Department = "IT Support",
                EmploymentType = EmploymentType.Hourly,
                HourlyRate = 35.00m,
                HireDate = new DateTime(2024, 2, 1)
            }
        };

        context.Employees.AddRange(employees);
        context.SaveChanges();
    }
}
