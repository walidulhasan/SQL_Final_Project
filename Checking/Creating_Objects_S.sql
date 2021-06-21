
USE master
GO


DROP DATABASE IF EXISTS projectPointOfSales_DB
GO


CREATE DATABASE projectPointOfSales_DB
ON
(
	NAME= pointOfSales_DB,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\projectPointOfSales_DB.mdf',
	SIZE=10MB,
	MAXSIZE=1GB,
	FILEGROWTH=10%
)
LOG ON
(
	NAME=pointOfSales_DB_log,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\projectPointOfSales_DB_log.ldf',
	SIZE=2MB,
	MAXSIZE=25MB,
	FILEGROWTH=1MB
)
GO

USE projectPointOfSales_DB 
GO


CREATE TABLE tblGender
(
	genderID INT PRIMARY KEY IDENTITY,
	gender VARCHAR(6) NOT NULL
)
GO

CREATE TABLE tblDesignations
(
	designationID INT PRIMARY KEY IDENTITY,
	designation VARCHAR(30) NOT NULL
)
GO

CREATE TABLE tblCustomers
(
	customerID INT PRIMARY KEY IDENTITY,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(40) NOT NULL,
	genderID INT REFERENCES tblGender(genderID) NOT NULL,
	birthDate DATETIME,
	contactNo VARCHAR(15) NOT NULL,
	email VARCHAR(70),
	streetAddress VARCHAR(100),
	postalCode INT,
	city VARCHAR(30)
)
GO


CREATE TABLE tblEmployees
(
	employeeID INT PRIMARY KEY IDENTITY,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(40) NOT NULL,
	nationalIDNo CHAR(13) UNIQUE NOT NULL CHECK(nationalIDNo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	genderID INT REFERENCES tblGender(genderID) NOT NULL,
	designationID INT REFERENCES tblDesignations(designationID) NOT NULL,
	birthDate DATETIME NOT NULL,
	contactNo VARCHAR(15) NOT NULL,
	email VARCHAR(70) NOT NULL,
	streetAddress VARCHAR(100) NOT NULL,
	postalCode INT NOT NULL,
	city VARCHAR(30) NOT NULL,
	empPhoto VARBINARY(MAX)
)
GO

CREATE TABLE tblSuppliers
(
	supplierID INT IDENTITY PRIMARY KEY,
	companyName VARCHAR(70) NOT NULL,
	contactFirstName VARCHAR(50),
	contactLastName VARCHAR(40),
	contactNo VARCHAR(15) UNIQUE NOT NULL,
	email VARCHAR(70),
	fax VARCHAR(20),
	streetAddress VARCHAR(100),
	postalCode INT,
	city VARCHAR(20)
)
GO

CREATE TABLE tblCategories
(
	categoryID INT IDENTITY PRIMARY KEY,
	categoryName VARCHAR(40) NOT NULL,
	categoryDescription VARCHAR(200)
)
GO

CREATE TABLE tblProducts
(
	productID INT IDENTITY PRIMARY KEY,
	productName VARCHAR(50) NOT NULL,
	catagoryID INT REFERENCES tblCategories(categoryID),
	supplierID INT REFERENCES tblSuppliers(supplierID),
	size INT,
	sizeUnit VARCHAR(20),
	purchasePrice MONEY,
	retailPrice MONEY,
	discountRate FLOAT,
	note VARCHAR(200),
	productImage VARBINARY(MAX)
)
GO

CREATE TABLE tblStock
(
	stockID	INT PRIMARY KEY IDENTITY,
	productID INT REFERENCES tblProducts(productID) UNIQUE,
	quantity INT CHECK(quantity>=0),
	quantityUnit VARCHAR(20)
)
GO

CREATE TABLE tblSales
(
	salesID INT IDENTITY PRIMARY KEY,
	customerID INT REFERENCES tblCustomers(customerID),
	employeeID INT REFERENCES tblEmployees(employeeID),
	salesDate DATETIME DEFAULT GETDATE(),
	grossPrice MONEY,
	discount MONEY,
	netPay AS grossPrice-discount
)
GO

CREATE TABLE tblSalesDetails
(
	salesID INT REFERENCES tblSales(salesID),
	productID INT REFERENCES tblProducts(productID),
	quantity INT NOT NULL CHECK(quantity>0),
	price MONEY,
	discountRate FLOAT,
	amount AS quantity*price,
	discount AS price * discountRate*quantity,
	netPrice AS (price*quantity)-(price * discountRate*quantity)
	PRIMARY KEY(salesID,productID)
)
GO

CREATE TABLE tblPurchase
(
	purchaseID INT IDENTITY PRIMARY KEY,
	supplierID INT REFERENCES tblSuppliers(supplierID),
	purchaseDate DATETIME DEFAULT GETDATE(),
	grossPrice MONEY,
	discountRate FLOAT,
	discount AS grossPrice*discountRate,
	netPay AS grossPrice-(grossPrice*discountRate)
)
GO

CREATE TABLE tblPurchaseDetails
(
	purchaseID INT REFERENCES tblPurchase(purchaseID),
	productID INT REFERENCES tblProducts(productID),
	quantity INT NOT NULL CHECK(quantity>0),
	price MONEY,
	amount AS quantity*price,
	PRIMARY KEY(purchaseID,productID)
)
GO


CREATE TABLE tblLogin
(
	employeeID INT PRIMARY KEY REFERENCES tblEmployees(employeeID),
	userName VARCHAR(20) UNIQUE NOT NULL,
	empPassword VARCHAR(50) NOT NULL CHECK (LEN(empPassword) >=6)
)
GO



--INSERTING DATA TO GENDER TABLE

INSERT INTO tblGender VALUES('Male'),('Female')
GO

--INSERTING DATA FOR LOGIN PURPOSE
INSERT INTO tblDesignations VALUES('Administrator')
INSERT INTO tblDesignations VALUES('Manager')
INSERT INTO tblDesignations VALUES('Sales Person')
INSERT INTO tblEmployees (firstName,lastName,nationalIDNo,genderID,designationID,birthDate,contactNo,email,streetAddress,postalCode,city) VALUES('ADMIN','N/A','0000000000000',1,1,GETDATE(),'00000000000','admin@admin.com','N/A',0000,'N/A')
INSERT INTO tblLogin VALUES(1,'admin','123456')

GO
--RISTRICT GENDER TABLE FROM MODIFYING

CREATE TRIGGER trLockGenderTable
	ON tblGender
	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify this table!'
	ROLLBACK TRANSACTION
GO


--STORED PROCEDURE FOR INSERTING DATA TO DESIGNATION TABLE 

CREATE PROCEDURE spInsertDesignation
					@designation VARCHAR(30)

AS
BEGIN
	INSERT INTO tblDesignations VALUES(@designation)
END
GO


--STORED PROCEDURE FOR UPDATING DATA TO DESIGNATION TABLE 

CREATE PROCEDURE spUpdateDesignation
					@id int,
					@designation VARCHAR(30)

AS
BEGIN
	UPDATE tblDesignations
	SET designation=@designation
	WHERE designationID=@id
END
GO


--STORED PROCEDURE FOR DELETING DATA TO DESIGNATION TABLE 

CREATE PROCEDURE spDeleteDesignation
					@id int

AS
BEGIN
	DELETE tblDesignations
	WHERE designationID=@id
END
GO

--STORED PROCEDURE FOR INSERTING DATA TO CUSTOMERS TABLE 

CREATE PROCEDURE spInsertCustomers
					@firstName VARCHAR(50),
					@lastName VARCHAR(40),
					@genderID INT,
					@birthDate DATETIME,
					@contactNo VARCHAR(15),
					@email VARCHAR(70),
					@streetAddress VARCHAR(100),
					@postalCode INT,
					@city VARCHAR(30)

AS
BEGIN
	INSERT INTO tblCustomers VALUES
		(@firstName,@lastName,@genderID,@birthDate,@contactNo,@email,@streetAddress,@postalCode,@city)
END
GO

--STORED PROCEDURE FOR DELETING DATA TO CUSTOMERS TABLE 

CREATE PROCEDURE spDeleteCustomers
					@id int

AS
BEGIN
	DELETE tblCustomers
	WHERE customerID=@id
END
GO


--STORED PROCEDURE FOR INSERTING DATA TO EMPLOYEES TABLE 

CREATE PROCEDURE spInsertEmployees
					@firstName VARCHAR(50),
					@lastName VARCHAR(40),
					@nationalIDNo CHAR(13),
					@genderID INT,
					@designationID INT,
					@birthDate DATETIME,
					@contactNo VARCHAR(15),
					@email VARCHAR(70),
					@streetAddress VARCHAR(100),
					@postalCode INT,
					@city VARCHAR(30),
					@photo VARBINARY(MAX)

AS
BEGIN
	INSERT INTO tblEmployees VALUES
		(@firstName,@lastName,@nationalIDNo,@genderID,@designationID,@birthDate,@contactNo,@email,@streetAddress,@postalCode,@city,@photo)
END
GO

CREATE PROCEDURE spInsertEmployeesWithoutPhoto
					@firstName VARCHAR(50),
					@lastName VARCHAR(40),
					@nationalIDNo CHAR(13),
					@genderID INT,
					@designationID INT,
					@birthDate DATETIME,
					@contactNo VARCHAR(15),
					@email VARCHAR(70),
					@streetAddress VARCHAR(100),
					@postalCode INT,
					@city VARCHAR(30)

AS
BEGIN
	INSERT INTO tblEmployees (firstName,lastName,nationalIDNo,genderID,designationID,birthDate,contactNo,email,streetAddress,postalCode,city) VALUES
		(@firstName,@lastName,@nationalIDNo,@genderID,@designationID,@birthDate,@contactNo,@email,@streetAddress,@postalCode,@city)
END
GO

--STORED PROCEDURE FOR DELETING DATA TO EMPLOYEES TABLE 

CREATE PROCEDURE spDeleteEmployees
					@id int

AS
BEGIN
	DELETE tblEmployees
	WHERE employeeID=@id
END
GO




--STORED PROCEDURE FOR INSERTING DATA TO SUPPLIERS TABLE 

CREATE PROCEDURE spInsertSuppliers
						@companyName VARCHAR(70),
						@contactFirstName VARCHAR(50),
						@contactLastName VARCHAR(40),
						@contactNo VARCHAR(15),
						@email VARCHAR(70),
						@fax VARCHAR(20),
						@streetAddress VARCHAR(100),
						@postalCode INT,
						@city VARCHAR(20)

AS
BEGIN
	INSERT INTO tblSuppliers VALUES
		(@companyName,@contactFirstName,@contactLastName,@contactNo,@email,@fax,@streetAddress,@postalCode,@city)
END
GO


--STORED PROCEDURE FOR DELETING DATA TO SUPPLIERS TABLE 

CREATE PROCEDURE spDeleteSuppliers 
					@id int

AS
BEGIN
	DELETE tblSuppliers
	WHERE supplierID=@id
END
GO

--STORED PROCEDURE FOR INSERTING DATA TO CAREGORIES TABLE 

CREATE PROCEDURE spInsertCategories
						@categoryName VARCHAR(30),
						@categoryDescription VARCHAR(200)

AS
BEGIN
	INSERT INTO tblCategories VALUES
		(@categoryName,@categoryDescription)
END
GO

--STORED PROCEDURE FOR DELETING DATA TO CAREGORIES TABLE 

CREATE PROCEDURE spDeleteCategories
					@id int

AS
BEGIN
	DELETE tblCategories
	WHERE categoryID=@id
END
GO



--STORED PROCEDURE FOR INSERTING DATA TO PRODUCTS TABLE 

CREATE PROCEDURE spInsertProducts
							@productName VARCHAR(50),
							@catagoryID INT,
							@supplierID INT,
							@size INT,
							@sizeUnit VARCHAR(20),
							@purchasePrice MONEY,
							@retailPrice MONEY,
							@discountRate FLOAT,
							@note VARCHAR(200),
							@initialStock INT,
							@quantityUnit VARCHAR(20),
							@photo VARBINARY(MAX)

AS
BEGIN
	INSERT INTO tblProducts VALUES
		(@productName,@catagoryID,@supplierID,@size,@sizeUnit,@purchasePrice,@retailPrice,@discountRate,@note,@photo)
	DECLARE @ID INT;
	SET @ID=@@IDENTITY
	INSERT INTO tblStock VALUES(@@IDENTITY,@initialStock,@quantityUnit)
END
GO



--STORED PROCEDURE FOR DELETING DATA TO PRODUCTS TABLE 

CREATE PROCEDURE spDeleteFromProducts
					@id int

AS
BEGIN
	DELETE FROM tblProducts
	WHERE productID=@id
END
GO




--STORED PROCEDURE FOR UPDATING PRICE & DISCOUNT RATE TO PRODUCTS TABLE 

CREATE PROCEDURE spUpdateProducts
					@productID INT,
					@purchasePrice MONEY,
					@retailPrice MONEY,
					@discountRate FLOAT

AS
BEGIN
	UPDATE tblProducts
	SET purchasePrice=@purchasePrice,
		retailPrice=@retailPrice,
		discountRate=@discountRate
	WHERE productID=@productID
END
GO



--STORED PROCEDURE FOR INSERTING DATA TO SALES TABLE 

CREATE PROCEDURE spInsertSales
						@customerID INT,
						@employeeID INT

AS
BEGIN
	INSERT INTO tblSales(customerID,employeeID,salesDate) VALUES
		(@customerID,@employeeID,GETDATE())
END
GO

--STORED PROCEDURE FOR ADDING PRODUCTS TO SALESDETAILS TABLE 

CREATE PROCEDURE spAddProductToSales
							@salesID INT,
							@productID INT,
							@quantity INT

AS
BEGIN
	DECLARE @price MONEY;
	DECLARE @discountRate FLOAT;
	SELECT @price=retailPrice FROM tblProducts WHERE productID=@productID
	SELECT @discountRate=discountRate FROM tblProducts WHERE productID=@productID
	INSERT INTO tblSalesDetails(salesID,productID,quantity,price,discountRate) VALUES
			(@salesID,@productID,@quantity,@price,@discountRate)
END
GO

--TRIGGER FOR AOUTOMATIC UPDATE SALES AND STOCK TABLE



CREATE TRIGGER trAddproductToSales
    ON tblSalesDetails
    AFTER INSERT
	AS
    BEGIN
	--UPDATING STOCK
		DECLARE @quantity INT;
		DECLARE @productID INT;
		SELECT @productID=productID FROM inserted
		SELECT @quantity=quantity FROM inserted
		UPDATE tblStock
		SET quantity=quantity-@quantity
		WHERE productID=@productID
	--UPDATING SALES
		DECLARE @grossAmount MONEY;
		DECLARE @discount MONEY;
		DECLARE @ID INT;
		SELECT @ID=salesID FROM inserted
		SELECT @grossAmount=SUM(amount)  FROM tblSalesDetails WHERE salesID=@ID
		SELECT @discount=SUM(discount)  FROM tblSalesDetails WHERE salesID=@ID
		UPDATE tblSales
		SET grossPrice=@grossAmount
		WHERE salesID=@ID
		UPDATE tblSales
		SET discount=@discount
		WHERE salesID=@ID
    END
GO


--PREVENTING DELETATION FROM SALES TABLE
CREATE TRIGGER trRistrictDeleteFromSales
ON tblSales
FOR DELETE
AS
BEGIN
 ROLLBACK TRANSACTION
 PRINT 'Data cannot be deleted from sales record'
END
GO


--STORED PROCEDURE FOR INSERTING DATA TO PURCHASE TABLE 

CREATE PROCEDURE spInsertPurchase
						@supplierID INT,
						@discountRate FLOAT

AS
BEGIN
	INSERT INTO tblPurchase(supplierID,purchaseDate,discountRate) VALUES
		(@supplierID,GETDATE(),@discountRate)
END
GO


--STORED PROCEDURE FOR ADDING PRODUCTS TO PURCHASEDETAILS TABLE 

CREATE PROCEDURE spAddProductToPurchase
							@purchaseID INT,
							@productID INT,
							@quantity INT

AS
BEGIN
	DECLARE @price MONEY;
	SELECT @price=purchasePrice FROM tblProducts WHERE productID=@productID
	INSERT INTO tblPurchaseDetails(purchaseID,productID,quantity,price) VALUES
			(@purchaseID,@productID,@quantity,@price)
END
GO

--TRIGGER FOR AOUTOMATIC UPDATE PURCHASE AND STOCK TABLE



CREATE TRIGGER trAddproductToPurchase
    ON tblPurchaseDetails
    AFTER INSERT
	AS
    BEGIN
	--UPDATING STOCK
		DECLARE @quantity INT;
		DECLARE @productID INT;
		SELECT @productID=productID FROM inserted
		SELECT @quantity=quantity FROM inserted
		UPDATE tblStock
		SET quantity=quantity+@quantity
		WHERE productID=@productID
	--UPDATING PURCHASE
		DECLARE @grossAmount MONEY;
		DECLARE @ID INT;
		SELECT @ID=purchaseID FROM inserted
		SELECT @grossAmount=SUM(amount)  FROM tblPurchaseDetails WHERE purchaseID=@ID
		UPDATE tblPurchase
		SET grossPrice=@grossAmount
		WHERE purchaseID=@ID
    END
GO


--PREVENTING DELETATION FROM SALES TABLE
CREATE TRIGGER trRistrictDeleteFrompurchase
ON tblPurchase
FOR DELETE
AS
BEGIN
 ROLLBACK TRANSACTION
 PRINT 'Data cannot be deleted from purchase record'
END
GO




--VIEW FOR EMPLOYEE WISE SALES
CREATE VIEW vEmployeeWiseSales
AS
SELECT E.employeeID,E.firstName,E.lastName,D.designation,G.gender,SUM(S.grossPrice) [total Sales] FROM tblSales S
JOIN tblEmployees E ON E.employeeID= S.employeeID
JOIN tblGender G ON G.genderID=E.genderID
JOIN tblDesignations D ON D.designationID=E.designationID 
GROUP BY E.employeeID,E.firstName,E.lastName,D.designation,G.gender
GO


--creating INDEX


CREATE INDEX iProductName
ON tblProducts(productName)
GO

--Function for employee sales

CREATE FUNCTION fnEmployeeSales
(
   @employeeID INT
)
RETURNS TABLE
AS 
RETURN
(SELECT E.employeeID,E.firstName,E.lastName,D.designation,G.gender,SUM(S.grossPrice) [total Sales] FROM tblSales S
JOIN tblEmployees E ON E.employeeID= S.employeeID
JOIN tblGender G ON G.genderID=E.genderID
JOIN tblDesignations D ON D.designationID=E.designationID 
WHERE E.employeeID=@employeeID
GROUP BY E.employeeID,E.firstName,E.lastName,D.designation,G.gender
)
GO

--function for monthly product wise sales

CREATE FUNCTION fnEmployeeWiseSales
(
    @monthNO INT,
	@year INT
)
RETURNS @EmployeeWiseSales TABLE 
(
	employeeID int,
	lastName char(40),
	designation char(20),
	gender char(6),
	totalSales MONEY
)
AS
BEGIN
		INSERT @EmployeeWiseSales
		SELECT E.employeeID,E.lastName,D.designation,G.gender,SUM(S.grossPrice) [total Sales] FROM tblSales S
		JOIN tblEmployees E ON E.employeeID= S.employeeID
		JOIN tblGender G ON G.genderID=E.genderID
		JOIN tblDesignations D ON D.designationID=E.designationID 
		WHERE MONTH(S.salesDate)=@monthNO AND YEAR(S.salesDate)=@year
		GROUP BY E.employeeID,E.firstName,E.lastName,D.designation,G.gender
		RETURN 
END
GO

--FUNCTION FOR MONTHLY TOTAL DISCOUNT

CREATE FUNCTION fnMonthlyTotalDiscount
(
    @monthNO INT,
	@year INT
)
RETURNS MONEY
AS
BEGIN

    RETURN (SELECT SUM(discount) FROM tblSales WHERE MONTH(salesDate)=@monthNO AND YEAR(salesDate)=@year)

END
GO


CREATE PROC spMonthlyTotalSales 
							@fromDate DATETIME,
							@toDate DATETIME
							
AS
BEGIN
SELECT E.employeeID,E.firstName+' '+E.lastName [Full Name],D.designation,G.gender,SUM(S.grossPrice) [Total Sales] FROM tblSales S
JOIN tblEmployees E ON E.employeeID= S.employeeID
JOIN tblGender G ON G.genderID=E.genderID
JOIN tblDesignations D ON D.designationID=E.designationID 
WHERE S.salesDate BETWEEN @fromDate AND @toDate
GROUP BY E.employeeID,E.firstName,E.lastName,D.designation,G.gender
END
GO

