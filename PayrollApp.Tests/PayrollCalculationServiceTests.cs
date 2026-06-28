using Xunit;

using PayrollApp.Models;
using PayrollApp.Services;

namespace PayrollApp.Tests;

public class PayrollCalculationServiceTests
{
    private readonly PayrollCalculationService _service = new();

    [Fact]
    public void CalculateGrossPay_ForSalariedEmployee_ReturnsMonthlySalary()
    {
        var employee = CreateSalariedEmployee(annualSalary: 72000m);

        var grossPay = _service.CalculateGrossPay(employee);

        Assert.Equal(6000m, grossPay);
    }

    [Fact]
    public void CalculateGrossPay_ForHourlyEmployee_UsesProvidedHours()
    {
        var employee = CreateHourlyEmployee(hourlyRate: 30m);

        var grossPay = _service.CalculateGrossPay(employee, hoursWorked: 120m);

        Assert.Equal(3600m, grossPay);
    }

    [Fact]
    public void CalculateTax_RoundsToTwoDecimals()
    {
        var tax = _service.CalculateTax(1234.567m);

        Assert.Equal(172.84m, tax);
    }

    [Fact]
    public void CalculateSocialSecurity_RoundsToTwoDecimals()
    {
        var socialSecurity = _service.CalculateSocialSecurity(1234.567m);

        Assert.Equal(76.54m, socialSecurity);
    }

    [Fact]
    public void CalculateTotalDeductions_SumsAllComponents()
    {
        var totalDeductions = _service.CalculateTotalDeductions(100m, 50m, 200m);

        Assert.Equal(350m, totalDeductions);
    }

    [Fact]
    public void CalculateNetPay_RoundsToTwoDecimals()
    {
        var netPay = _service.CalculateNetPay(1234.567m, 321.111m);

        Assert.Equal(913.46m, netPay);
    }

    [Fact]
    public void ProcessPayroll_ForHourlyEmployee_ReturnsExpectedRecord()
    {
        var employee = CreateHourlyEmployee(hourlyRate: 25m);
        var payPeriodStart = new DateTime(2026, 6, 1);
        var payPeriodEnd = new DateTime(2026, 6, 15);

        var payrollRecord = _service.ProcessPayroll(employee, payPeriodStart, payPeriodEnd, hoursWorked: 80m);

        Assert.Equal(employee.Id, payrollRecord.EmployeeId);
        Assert.Equal(payPeriodStart, payrollRecord.PayPeriodStart);
        Assert.Equal(payPeriodEnd, payrollRecord.PayPeriodEnd);
        Assert.Equal(80m, payrollRecord.HoursWorked);
        Assert.Equal(2000m, payrollRecord.GrossPay);
        Assert.Equal(280m, payrollRecord.TaxAmount);
        Assert.Equal(124m, payrollRecord.SocialSecurityAmount);
        Assert.Equal(200m, payrollRecord.HealthInsuranceAmount);
        Assert.Equal(604m, payrollRecord.TotalDeductions);
        Assert.Equal(1396m, payrollRecord.NetPay);
    }

    private static Employee CreateSalariedEmployee(decimal annualSalary)
    {
        return new Employee
        {
            Id = 1,
            EmployeeId = "EMP001",
            Name = "Salaried Employee",
            Email = "salaried@example.com",
            EmploymentType = EmploymentType.Salaried,
            AnnualSalary = annualSalary
        };
    }

    private static Employee CreateHourlyEmployee(decimal hourlyRate)
    {
        return new Employee
        {
            Id = 2,
            EmployeeId = "EMP002",
            Name = "Hourly Employee",
            Email = "hourly@example.com",
            EmploymentType = EmploymentType.Hourly,
            HourlyRate = hourlyRate
        };
    }
}
