
--Creating Objects

USE master
GO

DROP DATABASE IF EXISTS humanResourceManagement_DB
GO

CREATE DATABASE humanResourceManagement_DB
ON
(
	NAME= humanResource_DB_Data,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\humanResource_DB_Data.mdf',
	SIZE=100MB,
	MAXSIZE=500MB,
	FILEGROWTH=5%
)
LOG ON
(
	NAME=humanResource_DB_log,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\humanResource_DB_log.ldf',
	SIZE=50MB,
	MAXSIZE=200MB,
	FILEGROWTH=5%
)
GO

USE humanResourceManagement_DB
GO

CREATE TABLE tbl_department
(
	departmentID INT IDENTITY PRIMARY KEY,
	departmentName VARCHAR(15) NOT NULL,
)
GO
CREATE TABLE tbl_designation
(
	designationID INT IDENTITY PRIMARY KEY,
	departmentID INT REFERENCES tbl_department(departmentID),
	designationTitle VARCHAR(20) NOT NULL,
	salaryAmount MONEY
)
GO
CREATE TABLE tbl_status
(
	statusID INT IDENTITY PRIMARY KEY,
	statusName VARCHAR(15) NOT NULL
)
GO
CREATE TABLE tbl_gender
(
	genderID INT PRIMARY KEY IDENTITY,
	gender VARCHAR(6) NOT NULL
)
GO
CREATE TABLE tbl_leaveType
(
	leaveTypeID INT IDENTITY PRIMARY KEY,
	typeName VARCHAR(15) NOT NULL
)
GO
CREATE TABLE tbl_projects
(
	projectID INT IDENTITY PRIMARY KEY, 
	projectName VARCHAR(50) NOT NULL,
	cost MONEY NOT NULL, 
	duration INT NOT NULL
)
GO
CREATE TABLE tbl_yearlyLeave
(
	yearlyLeaveID INT PRIMARY KEY IDENTITY,
	designationID INT REFERENCES tbl_designation(designationID),
	totalLeaveDays INT NOT NULL
)
GO
CREATE TABLE tbl_employee
(
	employeeID INT PRIMARY KEY IDENTITY(101,1),
	firstName VARCHAR(20) NOT NULL,
	lastName VARCHAR(20) NOT NULL,
	nationalIDNo CHAR(13) UNIQUE NOT NULL CHECK(nationalIDNo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	genderID INT REFERENCES tbl_gender(genderID) NOT NULL,
	designationID INT REFERENCES tbl_designation(designationID) NOT NULL,
	birthDate DATETIME NOT NULL,
	contactNo VARCHAR(15) NOT NULL,
	email VARCHAR(70) NOT NULL,
	streetAddress VARCHAR(100) NOT NULL,
	postalCode INT NOT NULL,
	city VARCHAR(20) NOT NULL DEFAULT 'Dhaka',
	country VARCHAR(25) NOT NULL
)
GO
CREATE TABLE tbl_employeeStatus
(
	statusID INT REFERENCES tbl_status(statusID),
	employeeID INT UNIQUE REFERENCES tbl_employee(employeeID),
	statusDesc VARCHAR(100),
	PRIMARY KEY(statusID,employeeID)
)
GO
CREATE TABLE tbl_employeeProject
(
	employeeID INT REFERENCES tbl_employee(employeeID),
	projectID INT REFERENCES tbl_projects(projectID),
	assignDate DATE NOT NULL,
	PRIMARY KEY(employeeID,projectID)
)
GO
CREATE TABLE tbl_employeeLeave
(
	empLeaveID INT PRIMARY KEY IDENTITY,
	employeeID INT REFERENCES tbl_employee(employeeID),
	leaveTypeID INT REFERENCES tbl_leaveType(leaveTypeID),
	leaveReason VARCHAR(100) NOT NULL,
	leaveDays INT NOT NULL,
	fromDate DATE NOT NULL CHECK(fromDate>=GETDATE()),
	toDate DATE NOT NULL,
	leaveIssueDate DATE DEFAULT GETDATE(),
	CHECK(toDate>fromDate)
)
GO--End of object creation

/*
* INSERT DATA TO STATUS TABLE
*/

INSERT INTO tbl_status VALUES('Active')
INSERT INTO tbl_status VALUES('Retired')
INSERT INTO tbl_status VALUES('On-hold')
INSERT INTO tbl_status VALUES('Suspended')
GO

/*
* INSERT DATA TO GENDER TABLE
*/

INSERT INTO tbl_gender VALUES
('Male'),
('Female')
GO

/*
* Create TRIGGER for preventing tbl_status from modification
*/

CREATE TRIGGER tr_lockStatusTableMofication
	ON tbl_status
	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify or delete STATUS table!'
	ROLLBACK TRANSACTION
GO

/*
* Insert data into tbl_department table
*/

INSERT INTO tbl_department VALUES
('Admin'),
('Development'),
('Marketing')
GO

/*
* Create stored procedure for INSERTING data into tbl_designation table
*/

CREATE PROC sp_insertDesignation
			@deptID INT,
			@title VARCHAR(20),
			@amount MONEY
AS
BEGIN
	INSERT INTO tbl_designation VALUES(@deptID,@title,@amount)
END
GO

/*
* Create stored procedure for DELETING data from tbl_designation table
*/

CREATE PROC sp_deleteDesignation
			@id INT
AS
BEGIN
	DELETE FROM tbl_designation 
	WHERE designationID=@id
END
GO

/*
* Create TRIGGER for preventing gender from modification
*/

CREATE TRIGGER tr_lockGenderMofication
	ON tbl_gender
	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify or delete GENDER!'
	ROLLBACK TRANSACTION
GO

/*
* Create stored procedure for INSERTING data into tbl_leaveType table
*/

CREATE PROC sp_insertLeaveType
			@typeName VARCHAR(15)
AS
BEGIN
	INSERT INTO tbl_leaveType VALUES(@typeName)
END
GO
--TEST
EXEC sp_insertLeaveType 'Casual Leave'
EXEC sp_insertLeaveType 'Medical Leave'
GO

/*
* Create stored procedure for INSERTING data into tbl_yearlyLeave table
*/

CREATE PROC sp_insertYearlyLeave
			@designationID INT,
			@leaveDays INT
AS
BEGIN
	INSERT INTO tbl_yearlyLeave VALUES(@designationID,@leaveDays)
END
GO

/*
* Create stored procedure for DELETING data from tbl_yearlyLeave table
*/
CREATE PROC sp_deleteYearlyLeave
			@designationID INT
AS
BEGIN
	DELETE FROM tbl_yearlyLeave WHERE designationID=@designationID
END
GO

/*
* Create stored procedure for INSERTING data into tbl_employee table
*/

CREATE PROC sp_insertEmployee
			@fname VARCHAR(20),
			@lname VARCHAR(20),
			@nid CHAR(13),
			@genderID INT,
			@designationID INT,
			@dob DATETIME,
			@contactNo VARCHAR(15),
			@email VARCHAR(70),
			@streetAddress VARCHAR(100),
			@postalCode INT,
			@city VARCHAR(20),
			@country VARCHAR(25)
AS
BEGIN
	INSERT INTO tbl_employee VALUES(@fname,@lname,@nid,@genderID,@designationID,@dob,@contactNo,@email,@streetAddress,@postalCode,@city,@country)
END
GO

/*
* Create stored procedure for DELETE data from tbl_employee table
*/

CREATE PROC sp_deleteEmployee
			@employeeID INT
AS
BEGIN
	DELETE FROM tbl_employee
	WHERE employeeID=@employeeID
END
GO

/*
* Create stored procedure for INSERTING data into tbl_employeeStatus table
*/

CREATE PROC sp_insertEmployeeStatus
			@statusID INT,
			@employeeID INT,
			@description VARCHAR(100)
AS
BEGIN
	INSERT INTO tbl_employeeStatus VALUES(@statusID,@employeeID,@description)
END
GO

/*
* Create stored procedure for DELETING data from tbl_employeeStatus table
*/

CREATE PROC sp_deleteEmployeeStatus
			@employeeID INT
AS
BEGIN
	DELETE FROM tbl_employeeStatus WHERE employeeID=@employeeID
END
GO

/*
* Create stored procedure for INSERTING data into tbl_employeeLeave table
*/

CREATE PROC sp_insertEmployeeLeave
			@employeeID INT,
			@leaveTypeID INT,
			@leaveReason VARCHAR(100),
			@leaveDays INT,
			@fromDate DATE,
			@toDate DATE,
			@leaveIssueDate DATE
AS
BEGIN
	INSERT INTO tbl_employeeLeave VALUES(@employeeID,@leaveTypeID,@leaveReason,@leaveDays,@fromDate,@toDate,@leaveIssueDate)
END
GO

/*
* Create TRIGGER for preventing data DELETE & Update from tbl_employeeLeave table
*/

CREATE TRIGGER tr_lockEmployeeLeaveUpdateDelete
	ON tbl_employeeLeave
	FOR UPDATE,DELETE
AS
	PRINT 'You can''t update or delete employee leave table!'
	ROLLBACK TRANSACTION
GO

/*
* Create stored procedure for INSERTING data into tbl_projects table
*/

CREATE PROC sp_insertProjects
			@projectName VARCHAR(50),
			@cost MONEY,
			@duration INT
AS
BEGIN
	INSERT INTO tbl_projects VALUES(@projectName,@cost,@duration)
END
GO

/*
* Create stored procedure for INSERTING data into tbl_EmployeeProject table
*/

CREATE PROC sp_insertEmployeeProject
			@employeeID INT,
			@projectID INT,
			@date DATE
AS
BEGIN
	INSERT INTO tbl_employeeProject VALUES(@employeeID,@projectID,@date)
END
GO



-----------------------------------------------------
--
--SOME DATA ENTRY
--
-----------------------------------------------------

--INSERT INTO DESIGNATION TABLE
EXEC sp_insertDesignation 1,'Manager',50000
EXEC sp_insertDesignation 2,'Assistant Manager',40000
EXEC sp_insertDesignation 2,'Trainee Programmer',20000
EXEC sp_insertDesignation 1,'Cleaner',10000
EXEC sp_insertDesignation 3,'Driver',10000
GO

--INSERT INTO YEARLY LEAVE
EXEC sp_insertYearlyLeave 1,20
EXEC sp_insertYearlyLeave 2,15
EXEC sp_insertYearlyLeave 3,10
EXEC sp_insertYearlyLeave 4,5
GO


--INSERT INTO EMPLOYEE
EXEC sp_insertEmployee 'Mahmud','Sabuj','2345678765432',1,1,'11-19-1995','01912119319','hello@mahmudsabuj.com','Panthopoth, green road',1205,'Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Sharif','Mahmud','2345678456098',1,2,'04-14-1992','01912119348','sharif@gmail.com','Agargaon',1207,'Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Aman','Ullah','2345678765875',1,3,'01-23-1990','01912119316','aman@yahoo.com','Boddo mondir, Basabo',1212,'Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Rabeya','Khatun','2345678765099',2,4,'12-17-1981','01912119311','khala@ymail.com','Mohammod pur',1210,'Dhaka','Bangladesh'
GO

--INSERT INTO EMPLOYEE STATUS
EXEC sp_insertEmployeeStatus 1,101,'no comment'
EXEC sp_insertEmployeeStatus 1,102,'no comment'
EXEC sp_insertEmployeeStatus 3,103,'no comment'
EXEC sp_insertEmployeeStatus 1,104,'no comment'
GO

--INSERT INTO EMPLOYEE LEAVE
EXEC sp_insertEmployeeLeave 101,1,'Marriage Leave',10,'12/15/2020','12/25/2020','12/05/2020'
EXEC sp_insertEmployeeLeave 103,2,'For sickness',5,'12/18/2020','12/23/2020','12/05/2020'
GO

--INSERT INTO PROJECTS TABLE
EXEC sp_insertProjects 'School Management',50000,6
EXEC sp_insertProjects 'Logistic Software',100000,10
EXEC sp_insertProjects 'Bus Ticket Software',30000,4
EXEC sp_insertProjects 'HRM Software',500000,15
EXEC sp_insertProjects 'Library Management Sofware',80000,8
EXEC sp_insertProjects 'iPhone Application',50000,5
EXEC sp_insertProjects 'Android Application',70000,10
EXEC sp_insertProjects 'Blackberry Application',30000,8
EXEC sp_insertProjects 'Windows Application',40000,7
EXEC sp_insertProjects 'MacOS Application',200000,10
EXEC sp_insertProjects 'Linux Application',100000,12
EXEC sp_insertProjects 'Web Application',80000,9
EXEC sp_insertProjects 'Garments Application',500000,15
GO

--INSERT INTO EMPLOYEE PROJECT TABLE
EXEC sp_insertEmployeeProject 101,1,'11/01/2020'
EXEC sp_insertEmployeeProject 102,2,'11/06/2020'
EXEC sp_insertEmployeeProject 103,3,'11/03/2020'
EXEC sp_insertEmployeeProject 101,4,'11/02/2020'
EXEC sp_insertEmployeeProject 102,5,'11/03/2020'
EXEC sp_insertEmployeeProject 101,6,'11/05/2020'

EXEC sp_insertEmployeeProject 101,7,'12/08/2020'
EXEC sp_insertEmployeeProject 103,8,'12/07/2020'
EXEC sp_insertEmployeeProject 103,9,'12/09/2020'
EXEC sp_insertEmployeeProject 102,10,'12/13/2020'
EXEC sp_insertEmployeeProject 101,11,'12/18/2020'
EXEC sp_insertEmployeeProject 101,12,'12/20/2020'
GO
-----------------------------------------------------
--
--SOME CALCULATION
--
-----------------------------------------------------

--Create stored procedure for CALCULATING employee salary
--Add 10% bonus if NO leave count over the month
CREATE PROC sp_calcEmpSalaryWith10PercentBonusIfNoLeave
			@empID INT
AS
BEGIN
	select EmployeeName,salaryAmount 'Basic Salary',leaveDays,
	CASE
		WHEN leaveDays>0 THEN 0
		ELSE (salaryAmount*10/100)
	END Extra,
	CASE
		WHEN leaveDays>0 THEN salaryAmount
		ELSE (salaryAmount*110/100)
	END TotalSalary
	from (SELECT e.firstName+e.lastName EmployeeName,D.salaryAmount,el.leaveDays FROM tbl_employee e
	JOIN tbl_designation d ON d.designationID=e.designationID
	LEFT JOIN tbl_employeeLeave el ON el.employeeID=e.employeeID
	LEFT JOIN tbl_yearlyLeave yl ON yl.designationID=d.designationID
	WHERE e.employeeID=@empID) vtable	
END
GO


--CREATE TRIGGER FOR AUTOMATIC UPDATE EMPLOYEE STATUS
--SET EMPLOYEE STATUS TO 'ON-HOLD' IF EMPLOYEE INFORMATION UPDATED FROM tbl_employee
CREATE TRIGGER tr_updateEmpStatusOnEmpModification
    ON tbl_employee
    AFTER UPDATE
	AS
    BEGIN
	--UPDATING STOCK
		DECLARE @empID INT;
		SELECT @empID=employeeID FROM inserted
		UPDATE tbl_employeeStatus
		SET statusID=3
		WHERE employeeID=@empID
    END
GO

--PREVENT DELETE FROM tbl_yearlyLeave
CREATE TRIGGER tr_priventDeleteYearlyLeave
ON tbl_yearlyLeave
FOR DELETE
AS
BEGIN
 ROLLBACK TRANSACTION
 PRINT 'Sorry! You can''t delete leave records!'
END
GO

--FUNCTION
--CALCULATE EMPLOYEE SALARY AND BOUSE
--BASED ON PROJECT COMPLETE
-------project complete less than or equal 1 => add bonus 0.00
-------project complete more than or equal 2 and less than 5 => add bonus 10%
-------project complete more than or equal 5 => add bonus 15%
CREATE FUNCTION fn_MonthWiseEmployeeSalaryWithBonusOnProjectComplete
(
	@month INT,
	@year INT
)
RETURNS TABLE
AS
RETURN
(
	select EmployeeName,salaryAmount 'Basic Salary',TotalProjects,
	CASE
		WHEN TotalProjects<=1 THEN 0
		WHEN TotalProjects>=2 AND TotalProjects<5 THEN (salaryAmount*10/100)
		WHEN TotalProjects>=5 THEN (salaryAmount*15/100)
	END Bonus,
	CASE
		WHEN TotalProjects<=1 THEN 0
		WHEN TotalProjects>=2 THEN (salaryAmount*110/100)
		WHEN TotalProjects>=5 THEN (salaryAmount*115/100)
	END TotalSalary
	from (SELECT e.firstName+e.lastName EmployeeName,D.salaryAmount,COUNT(*) TotalProjects FROM tbl_employee e
	JOIN tbl_designation d ON d.designationID=e.designationID
	JOIN tbl_employeeProject ep ON ep.employeeID=e.employeeID
	JOIN tbl_projects p ON p.projectID=ep.projectID
	WHERE MONTH(ep.assignDate) IN(@month) AND YEAR(ep.assignDate) IN(@year)
	GROUP BY e.firstName+e.lastName,D.salaryAmount) vtable	
)
GO

-- INSTEAD OF TRIGGER
-- PREVENT ASSIGING PROJECT TO EMPLOYEE
-- CAN'T ASSIGN MORE THAN 3 PROJECTS EACH MONTH

CREATE TRIGGER tr_preventJobAssign
ON tbl_employeeProject
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @empID INT,@projectID INT, @assignDate DATE,@count INT
	SELECT @empID=employeeID,@projectID=projectID,@assignDate=assignDate FROM inserted
	SELECT @count=COUNT(employeeID) FROM tbl_employeeProject
	WHERE employeeID=@empID AND MONTH(assignDate)=MONTH(@assignDate)
	IF @count<3
		begin
			insert into tbl_employeeProject
			select employeeID,projectID,assignDate from inserted
		end
	ELSE
		BEGIN
			RAISERROR('You can''t assign more than 3 jobs each month',16,1)
		END
END
GO

--VIEW for department wise salary
CREATE VIEW view_DeptWiseSalary
AS
	SELECT dep.departmentName [Dept Name],SUM(d.salaryAmount) [Basic Salary] FROM tbl_employee e
	JOIN tbl_designation d ON d.designationID=e.designationID
	JOIN tbl_department dep ON dep.departmentID=d.departmentID
	LEFT JOIN tbl_employeeLeave el ON el.employeeID=e.employeeID
	LEFT JOIN tbl_yearlyLeave yl ON yl.designationID=d.designationID
	GROUP BY dep.departmentName WITH ROLLUP
GO

--Creating non clustered index ON national ID number for employee table
CREATE NONCLUSTERED INDEX NCI_emp_nid
ON tbl_employee(nationalIDNo)
GO

--Creating function for employee salary calculation
--And add bonus with salary if no leave over the month
CREATE FUNCTION fn_employeeSalaryWithBonus
(
	@empID INT,
	@bonus INT
)
RETURNS TABLE
AS
RETURN
(
	select EmployeeName,salaryAmount 'Basic Salary',leaveDays,
	CASE
		WHEN leaveDays>0 THEN 0
		ELSE (salaryAmount*(100+@bonus)/100)
	END Extra,
	CASE
		WHEN leaveDays>0 THEN salaryAmount
		ELSE (salaryAmount*110/100)
	END TotalSalary
	from (SELECT e.firstName+e.lastName EmployeeName,D.salaryAmount,el.leaveDays FROM tbl_employee e
	JOIN tbl_designation d ON d.designationID=e.designationID
	LEFT JOIN tbl_employeeLeave el ON el.employeeID=e.employeeID
	LEFT JOIN tbl_yearlyLeave yl ON yl.designationID=d.designationID
	WHERE e.employeeID=@empID) vtable
)
GO

--Creating function for to find out remaining leave days for employee
CREATE FUNCTION fn_empRemainingLeaveDays
(
	@empID INT
)
RETURNS @empRemainingLeaveDays TABLE
(
	empID INT,
	empName VARCHAR(50),
	remainingDays INT
)
AS
BEGIN
	INSERT @empRemainingLeaveDays
		SELECT e.employeeID,e.firstName+e.lastName,yl.totalLeaveDays-el.leaveDays FROM tbl_employee e
		JOIN tbl_designation d ON d.designationID=e.designationID
		LEFT JOIN tbl_employeeLeave el ON el.employeeID=e.employeeID
		LEFT JOIN tbl_yearlyLeave yl ON yl.designationID=d.designationID
		WHERE e.employeeID=@empID AND el.leaveDays>0
	RETURN
END
GO

