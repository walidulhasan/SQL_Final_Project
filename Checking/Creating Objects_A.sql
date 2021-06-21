
USE MASTER
GO

IF EXISTS (SELECT NAME FROM SYS.sysdatabases WHERE NAME= 'ISPDB')
DROP DATABASE  ISPDB
GO

CREATE DATABASE ISPDB
ON
(
	NAME= 'ISPDB_DATA_1',
	FILENAME= 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ISPDB_DATA_1.mdf',
	SIZE= 50 MB,
	MAXSIZE= 500 MB,
	FILEGROWTH= 15%
)
LOG ON
(
	NAME= 'ISPDB_LOG_1',
	FILENAME= 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ISPDB_LOG_1.ldf',
	SIZE= 30 MB,
	MAXSIZE= 100 MB,
	FILEGROWTH= 5 MB
)
GO

USE ISPDB
GO

CREATE TABLE pacKagePlan
(
	planID INT PRIMARY KEY IDENTITY,
	planName VARCHAR(20) NOT NULL,
	speed VARCHAR(15) NOT NULL,
	price MONEY NOT NULL
)
GO

CREATE TABLE customerType
(
	customerTypeID INT PRIMARY KEY,
	customerTypeName VARCHAR(10) NOT NULL
)
GO

CREATE TABLE paymentMethod
(
	paymentMethodID INT PRIMARY KEY,
	paymentMethodName VARCHAR(12) NOT NULL
)
GO

CREATE TABLE employeeType
(
	employeeTypeID INT PRIMARY KEY,
	employeeTypeName VARCHAR(20) NOT NULL
)
GO


CREATE TABLE officeAddress
(
	officeAddressID INT PRIMARY KEY,
	officeAddressName VARCHAR(50) NOT NULL
)
GO

CREATE TABLE employee
(
	employeeID INT PRIMARY KEY ,
	employeeFirstName VARCHAR(20) NOT NULL, 
	employeeLastName VARCHAR(10) NOT NULL,
	contactNumber VARCHAR(14) UNIQUE NOT NULL CHECK(contactNumber LIKE '[+][8][8][0][1][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	email VARCHAR(30) NOT NULL,
	dateOfBirth DATE NOT NULL,
	NID INT UNIQUE NOT NULL CHECK(NID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	address VARCHAR(20) NOT NULL,
	postalCode INT DEFAULT 'N/A',
	employeeTypeID INT REFERENCES employeeType(employeeTypeID),
	officeAddressID INT REFERENCES officeAddress (officeAddressID)

)
GO

CREATE TABLE serviceArea
(
	ServiceAreaID INT PRIMARY KEY,
	ServiceAreaName VARCHAR(20) NOT NULL,
	officeAddressID INT REFERENCES officeAddress (officeAddressID)
)
GO

CREATE TABLE customer
(
	customerID INT PRIMARY KEY IDENTITY(1001, 1),
	customerFirstName VARCHAR(20) NOT NULL,
	customerLastName VARCHAR(10) NOT NULL,
	contactNumber VARCHAR(14) UNIQUE NOT NULL CHECK(contactNumber LIKE '[+][8][8][0][1][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	address VARCHAR(20) NOT NULL,
	postalCode INT DEFAULT 'N/A',
	email VARCHAR(30) NOT NULL,
	IPNumber INT UNIQUE NOT NULL,
	connectionStartDate DATE NOT NULL,
	planID INT REFERENCES pacKagePlan(planID),
	customerTypeID INT REFERENCES customerType(customerTypeID),
	paymentMethodID INT REFERENCES paymentMethod(paymentMethodID),
	ServiceAreaID INT REFERENCES serviceArea(ServiceAreaID)
)
GO

-- CREATING STORED PROCEDURE FOR INSERTING INTO PACKAGE PLAN TABLE 

CREATE PROC spInsertIntoPackagePlan
	@planName VARCHAR(20),
	@speed VARCHAR(15),
	@price MONEY 

AS

INSERT INTO pacKagePlan VALUES 
(
	@planName, 
	@speed, 
	@price
)
GO

--CREATING STORED PROCEDURE FOR INSERTING INTO EMPLOYEE TABLE 

CREATE PROC spInsertIntoEmployee
	@employeeID INT,
	@employeeFirstName VARCHAR(20),
	@employeeLastName VARCHAR(10),
	@contactNumber VARCHAR(14),
	@email VARCHAR(30),
	@dateOfBirth DATE,
	@NID INT,
	@address VARCHAR(20),
	@postalCode INT,
	@employeeTypeID INT,
	@officeAddressID INT

AS

INSERT INTO employee VALUES
(
	@employeeID, 
	@employeeFirstName, 
	@employeeLastName, 
	@contactNumber, 
	@email, 
	@dateOfBirth, 
	@NID, 
	@address, 
	@postalCode, 
	@employeeTypeID, 
	@officeAddressID
)
GO

--CREATING STORED PROCEDURE FOR INSERTING INTO CUSTOMER TABLE 

CREATE PROC spInsertIntoCustomer
	@customerFirstName VARCHAR(20),
	@customerLastName VARCHAR(10),
	@contactNumber VARCHAR(14),
	@address VARCHAR(20),
	@postalCode INT,
	@email VARCHAR(30),
	@IPNumber INT,
	@connectionStartDate DATE,
	@planID INT,
	@customerTypeID INT,
	@paymentMethodID INT,
	@ServiceAreaID INT

AS

INSERT INTO customer VALUES 
(
	@customerFirstName, 
	@customerLastName, 
	@contactNumber, 
	@address, 
	@postalCode, 
	@email, 
	@IPNumber, 
	@connectionStartDate, 
	@planID, 
	@customerTypeID, 
	@paymentMethodID, 
	@ServiceAreaID
)
GO

--CREATING STORED PROCEDURE FOR UPDATING CUSTOMER TABLE 

CREATE PROC spUpdateToCustomer
	@customerFirstName VARCHAR(20),
	@customerLastName VARCHAR(10),
	@address VARCHAR(20),
	@postalCode INT,
	@ServiceAreaID INT,
	@IPNumber INT

AS

UPDATE customer 
SET customerFirstName=@customerFirstName,
	customerLastName=@customerLastName,
	address=@address,
	postalCode=@postalCode,
	ServiceAreaID=@ServiceAreaID
WHERE IPNumber=@IPNumber
GO

--CREATING STORED PROCEDURE FOR DELETING FROM CUSTOMER TABLE 

CREATE PROC spDeleteFromCustomer
	@IPNumber INT
AS

DELETE FROM customer
WHERE IPNumber=@IPNumber
GO

--CREATING STORED PROCEDURE WITH RETURN

CREATE PROC spInsertIntoCustomerWithReturn
	@customerFirstName VARCHAR(20),
	@customerLastName VARCHAR(10),
	@contactNumber VARCHAR(14),
	@address VARCHAR(20),
	@postalCode INT,
	@email VARCHAR(30),
	@IPNumber INT,
	@connectionStartDate DATE,
	@planID INT,
	@customerTypeID INT,
	@paymentMethodID INT,
	@ServiceAreaID INT

AS
BEGIN
	DECLARE @customerID INT
	INSERT INTO customer VALUES 
(
	@customerFirstName, 
	@customerLastName, 
	@contactNumber, 
	@address, 
	@postalCode, 
	@email, 
	@IPNumber, 
	@connectionStartDate, 
	@planID, 
	@customerTypeID, 
	@paymentMethodID, 
	@ServiceAreaID
)
	SELECT @customerID=(SELECT customerID FROM customer WHERE customerID=IDENT_CURRENT('customer'))
	RETURN @customerID
END
GO

--CREATING SCALAR FUNCTION FOR EMPLOYEE TABLE

CREATE FUNCTION fnCountServiceProviderFromEmployee 
(
	@employeeTypeID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @TotalCount INT
	SELECT @TotalCount=(SELECT COUNT(employeeTypeID) FROM employee WHERE employeeTypeID=@employeeTypeID)
	RETURN @TotalCount
END 
GO

--CREATING TABLE-VALUED FUNCTION FOR EMPLOYEE TABLE 

CREATE FUNCTION fnListOfServiceProvider 
(
	@employeeTypeID INT
)
RETURNS TABLE 
AS
RETURN
(
	SELECT employeeFirstName, employeeLastName, contactNumber, address, employeeTypeID, COUNT(employeeTypeID) AS Total_Count 
	From employee WHERE employeeTypeID=@employeeTypeID
	GROUP BY employeeFirstName, employeeLastName, contactNumber, address, employeeTypeID
)
GO

--CREATING TABLE-VALUED FUNCTION

CREATE FUNCTION fnAreaWisePriceSum
(
	@ServiceAreaName VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
	SELECT sa.ServiceAreaName, pp.planName, COUNT(c.ServiceAreaID) AS Total_Area, SUM(pp.price) AS Net_Income 
	FROM packagePlan pp
	INNER JOIN customer c ON pp.planID=c.planID
	INNER JOIN serviceArea sa ON c.ServiceAreaID=sa.ServiceAreaID
	WHERE sa.ServiceAreaName=@ServiceAreaName
	GROUP BY sa.ServiceAreaName, pp.planName
)
GO


--CREATING INDEX

CREATE NONCLUSTERED INDEX IX_customer
ON customer(customerID)
GO

--CREATING VIEW

CREATE VIEW vCorporateCustomer
AS
	SELECT c.customerFirstName, c.customerLastName,c.IPNumber, c.contactNumber, c.address, c.ServiceAreaID, pp.planName, pp.price, pp.speed 
	FROM customerType ct
	INNER JOIN customer c ON ct.customerTypeID=c.customerTypeID
	INNER JOIN pacKagePlan pp ON c.planID=pp.planID
	WHERE ct.customerTypeID=2
GO

--CREATING TRIGGER ON PACKAGE PLAN TABLE 

CREATE TRIGGER trInsertPackagePlanRestriction
ON pacKagePlan
FOR INSERT 
AS
BEGIN
	DECLARE @price MONEY
	SELECT @price=price FROM inserted
	IF @price <=600
		BEGIN
			RAISERROR('Plan Price Should not Below 600', 11, 1)
		END
END
GO

--CREATING TRIGGER ON CUSTOMER TYPE TABLE 

CREATE TRIGGER trInsertCustomerType
ON customerType
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @customerTypeID INT, @customerTypeName VARCHAR(10)
	SELECT @customerTypeID=customerTypeID, @customerTypeName=customerTypeName FROM inserted
	IF @customerTypeName is NULL
		BEGIN
			RAISERROR('Customer Type must be Included', 11, 1) 
		END
END 
GO

--CREATING TRIGGER ON EMPLOYEE TABLE (INSTEAD OF TRIGGER)

CREATE TRIGGER trRestrictDelete
ON employee
INSTEAD OF DELETE
AS
IF @@ROWCOUNT > 0
BEGIN
	RAISERROR('You are not permitted to delete data from this table', 11, 1)
END
GO













	 














