
/*
*
* SQL Project: Human resource management
* Project By: Md Shah Mahmud Sabuj
* Batch ID: ESAD-CS/PNTL-A/45/01
* Trainee ID: 1258657
*
*/

--> All Queries

USE humanResourceManagement_DB
GO

--> JOIN QUERY 
--> DEPARTMENT WISE EMPLOYEE SALARY with total
SELECT e.firstName,dep.departmentName,SUM(d.salaryAmount) Salary FROM tbl_employee e
JOIN tbl_designation d ON d.designationID=e.designationID
LEFT JOIN tbl_department dep ON dep.departmentID=d.departmentID
WHERE e.employeeID IN(SELECT employeeID FROM tbl_employee)
GROUP BY dep.departmentName,e.firstName WITH ROLLUP
GO

--> SUB QUERY
--> LEFT JOIN 
--> WHO DON'T HAVE LEAVE RECORD OVER THE MONTH
SELECT e.employeeID [ID],e.firstName [Name],e.email [Email],el.leaveDays [Leave Days] FROM tbl_employee e
LEFT JOIN tbl_employeeLeave el ON el.employeeID=e.employeeID
WHERE e.employeeID NOT IN(SELECT employeeID FROM tbl_employeeLeave)
GO

--> SUB QUERY 
--> HAVING CLAUSE
--> WHO COMPLETED 3 OR MORE PROJECTS OVER THE MONTH
SELECT e.employeeID [ID],e.firstName [Name],e.email [Email],COUNT(p.projectName) [Total Projects] FROM tbl_employee e
JOIN tbl_employeeProject ep ON ep.employeeID=e.employeeID
JOIN tbl_projects p ON p.projectID=ep.projectID
WHERE MONTH(ep.assignDate)=12 AND YEAR(ep.assignDate)=2020 -->FOR DECEMBER 2020
GROUP BY e.employeeID,e.firstName,e.email
HAVING COUNT(p.projectName) >=3
GO

--> TESTING VIEW
--> DEPARTMENT WISE SALARY
SELECT * FROM view_DeptWiseSalary
GO

--> TESTING FUNCTION fn_employeeSalaryWithBonus
--> EMPLOYEE SALARY WITH BONUS
SELECT * FROM fn_employeeSalaryWithBonus(101,20)
GO

--> TESTING FUNCTION fn_empRemainingLeaveDays
--> REMAINING LEAVE DAYS COUNT FOR SINGLE EMPLOYEE
SELECT * FROM fn_empRemainingLeaveDays(103)
GO

--> TESTING FUNCTION fn_MonthWiseEmployeeSalaryWithBonusOnProjectComplete
--> EMPLOYEE SALARY WITH BONUS BASED ON PROJECT COMPLETION
SELECT * FROM fn_MonthWiseEmployeeSalaryWithBonusOnProjectComplete(12,2020) --> DECEMBER 2020
GO

--> CTE - employee
WITH CTE_employees (firstName,departmentName, salaryAmount)
AS
(
SELECT e.firstName,dep.departmentName,SUM(d.salaryAmount) Salary FROM tbl_employee e
JOIN tbl_designation d ON d.designationID=e.designationID
LEFT JOIN tbl_department dep ON dep.departmentID=d.departmentID
WHERE e.employeeID IN(SELECT employeeID FROM tbl_employee)
GROUP BY dep.departmentName,e.firstName WITH ROLLUP
)
SELECT * FROM CTE_employees
GO

--> TABLE DETAILS
EXEC sp_help tbl_employee
GO

--> INDEX DETAILS
EXEC sp_helpindex tbl_employee
GO

--> CONSTRAINT DETAILS
EXEC sp_helpconstraint tbl_employee
GO

--> DATABASE INFORMATION
EXEC sp_helpdb humanResourceManagement_DB
GO