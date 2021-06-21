/*
								------SQL PROJECT----------
								Library Management System
								-----Creator of Project----
								Walidulhasan Boniamin
								Trainee Id: 1258683
								Batch ID: ESAD-CS/PNTL-A/45/01
						 -----------------------------------------
*/

USE master
GO

IF EXISTS(SELECT NAME FROM SYS.sysdatabases WHERE NAME='LibraryManagementSystem')
DROP DATABASE LibraryManagementSystem
GO

CREATE DATABASE LibraryManagementSystem
ON
(
	NAME='LibraryManagementSystem_Data',
	FILENAME='D:\New folder\LibraryManagementSystem_Data.mdf',
	SIZE=50MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%
)

LOG ON
(
	NAME='LibraryManagementSystem_Log',
	FILENAME='D:\New folder\LibraryManagementSystem_Log.ldf',
	SIZE=10MB,
	MAXSIZE=20MB,
	FILEGROWTH=5%
)
GO

USE LibraryManagementSystem
GO


CREATE TABLE tbl_Publication
(
	publicationID INT PRIMARY KEY IDENTITY ,
	publicationName NVARCHAR (40) NOT NULL
)
GO

CREATE TABLE tbl_Author
(
	authorID INT PRIMARY KEY IDENTITY,
	authorName NVARCHAR (40) NOT NULL,
)
GO


CREATE TABLE tbl_Genre
(
	catagoryID INT PRIMARY KEY IDENTITY,
	catagoryName VARCHAR (40) NOT NULL
)
GO
CREATE TABLE tbl_Books
(
	bookID INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	publicationID INT REFERENCES tbl_Publication (publicationID),
	authorID INT REFERENCES tbl_Author (authorID),
	catagoryID INT REFERENCES tbl_Genre (catagoryID),
	bName VARCHAR (50) NOT NULL,
	bDataEntry DATE NOT NULL,
	bCopy INT NOT NULL DEFAULT 0
)
GO

CREATE TABLE tbl_gender
(
	genderID INT PRIMARY KEY IDENTITY,
	gender VARCHAR(6) NOT NULL
)
GO 

CREATE TABLE tbl_designations
(
	designationID INT PRIMARY KEY IDENTITY(1000,1),
	designation VARCHAR(30) NOT NULL
)
GO

CREATE TABLE tbl_employees
(
	employeeID INT PRIMARY KEY IDENTITY(1001,1),
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(40) NOT NULL,
	genderID INT REFERENCES tbl_gender(genderID) NOT NULL,
	nationalIDNo CHAR(17) UNIQUE NOT NULL CHECK(nationalIDNo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	designationID INT REFERENCES tbl_designations(designationID) NOT NULL,
	birthDate DATE NOT NULL,
	contactNo VARCHAR(15) NOT NULL CHECK(contactNo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	streetAddress VARCHAR(100) NOT NULL,
	postalCode INT NOT NULL,
	city VARCHAR(30) NOT NULL
)
GO

CREATE TABLE tbl_Member
(
	memberID INT PRIMARY KEY IDENTITY(10000,1),
	firstName VARCHAR(50) NOT NULL,
	midName VARCHAR (50) NULL,
	lastName VARCHAR(40) NOT NULL,
	genderID INT REFERENCES tbl_gender(genderID) NOT NULL,
	contactNo VARCHAR(15) NOT NULL,
	memberAddress VARCHAR(100),
	postalCode INT,
	city VARCHAR(30),
	memberDate DATE NOT NULL
)
GO

CREATE TABLE tbl_Tranjection
(
	tranjectionID BIGINT PRIMARY KEY IDENTITY(10000001,1),
	memberID INT  REFERENCES tbl_Member (memberID),
	bookID INT  REFERENCES tbl_Books (bookID),
	dateIssue DATE DEFAULT GETDATE(),
	backDate DATE DEFAULT GETDATE()+10
)
GO


CREATE TABLE tbl_Fine
(
	fineID INT UNIQUE,
	tranjectionID BIGINT REFERENCES tbl_Tranjection(tranjectionID),
	fineAmount MONEY NOT NULL,
	PRIMARY KEY(tranjectionID,fineID),
	fstatus CHAR (10) NOT NULL
)
GO


--DATA INSERTING  TO Publication TABLE
INSERT INTO tbl_Publication VALUES ('BENGAL LIGHTS BOOKS')
INSERT INTO tbl_Publication VALUES ('Bloomsbury Publishing')
INSERT INTO tbl_Publication VALUES ('Bangla Kothon')
INSERT INTO tbl_Publication VALUES ('Books worls')
INSERT INTO tbl_Publication VALUES ('Booker')
INSERT INTO tbl_Publication VALUES ('LIGHTS BOOKS')
INSERT INTO tbl_Publication VALUES ('Bloomsbury')
INSERT INTO tbl_Publication VALUES ('Kothon')
INSERT INTO tbl_Publication VALUES ('worls')
INSERT INTO tbl_Publication VALUES ('Islamic Books')
INSERT INTO tbl_Publication VALUES ('BENGAL BOOKS')
INSERT INTO tbl_Publication VALUES ('Bloom Publishing')
INSERT INTO tbl_Publication VALUES ('Heor Kothon')
INSERT INTO tbl_Publication VALUES ('Magic bookres')
INSERT INTO tbl_Publication VALUES ('Man worls')
INSERT INTO tbl_Publication VALUES ('BTC book')
INSERT INTO tbl_Publication VALUES ('Bangla Sahitto')
GO

--DATA INSERTING  TO Author TABLE
INSERT INTO tbl_Author VALUES ('Kazi Nazrul Islam')
INSERT INTO tbl_Author VALUES ('Humaiun Ahamed')
INSERT INTO tbl_Author VALUES ('J.K.Rowling')
INSERT INTO tbl_Author VALUES ('Nazrul Islam')
INSERT INTO tbl_Author VALUES ('Kamal Ahamed')
INSERT INTO tbl_Author VALUES ('Nahar Begum')
INSERT INTO tbl_Author VALUES ('Sumiya Hossen')
INSERT INTO tbl_Author VALUES ('Siam kamal')
INSERT INTO tbl_Author VALUES ('Dr.Mohammed Sohidulla')
INSERT INTO tbl_Author VALUES ('Jahid ali')
INSERT INTO tbl_Author VALUES ('Johir Rayhan')
INSERT INTO tbl_Author VALUES ('Rrhila begum')
INSERT INTO tbl_Author VALUES ('Mamun Hossen')
INSERT INTO tbl_Author VALUES ('Rahila Begum')
INSERT INTO tbl_Author VALUES ('JK kamal')
INSERT INTO tbl_Author VALUES ('AH hossen')
INSERT INTO tbl_Author VALUES ('Moti miya')
INSERT INTO tbl_Author VALUES ('Humion azad')
INSERT INTO tbl_Author VALUES ('Safik miya')
GO

--DATA INSERTING  TO Category TABLE
INSERT INTO tbl_Genre VALUES 
('DRAMA'),
('NOVEL'),
('PROGRAMING'),
('POIM'),
('STORY')
GO


--DATA INSERTING  TO Books TABLE
INSERT INTO tbl_Books VALUES (17,19,5,'Chandro kotha','2020/09/09',10)
INSERT INTO tbl_Books VALUES (16,18,4,'Hazar Bochor Dhore','2020/09/09',23)
INSERT INTO tbl_Books VALUES (15,17,3,'Jahar lal','2020/09/09',4)
INSERT INTO tbl_Books VALUES (14,16,3,'Mina borue','2020/09/09',6)
INSERT INTO tbl_Books VALUES (13,15,2,'Sajer Bati','2020/09/09',89)
INSERT INTO tbl_Books VALUES (12,14,5,'Roktakto prantator','2020/09/09',4)
INSERT INTO tbl_Books VALUES (11,13,3,'Jibon niya','2020/09/09',6)
INSERT INTO tbl_Books VALUES (10,12,2,'Moner kotha','2020/09/09',89)
INSERT INTO tbl_Books VALUES (9,11,4,'Seler kobita','2020/09/09',4)
INSERT INTO tbl_Books VALUES (8,10,4,'Lalon sie','2020/09/09',6)
INSERT INTO tbl_Books VALUES (7,9,1,'Rather Agher','2020/09/09',89)
INSERT INTO tbl_Books VALUES (6,8,3,'Mon Bali','2020/09/09',6)
INSERT INTO tbl_Books VALUES (5,7,4,'Miya','2020/09/09',89)
INSERT INTO tbl_Books VALUES (4,6,2,'Rajok','2020/09/09',4)
INSERT INTO tbl_Books VALUES (3,5,1,'Shihan','2020/09/09',6)
INSERT INTO tbl_Books VALUES (1,4,5,'Riham','2020/09/09',89)
GO
--DATA INSERTING  TO gender TABLE
INSERT INTO tbl_gender VALUES ('MALE')
INSERT INTO tbl_gender VALUES ('FEMALE')
GO
--DATA INSERTING  TO designations TABLE
INSERT INTO tbl_designations VALUES ('MANAGER')
INSERT INTO tbl_designations VALUES ('SEEKER')
INSERT INTO tbl_designations VALUES ('STORE KEEPER')
INSERT INTO tbl_designations VALUES ('CLEANER')
GO
--DATA INSERTING  TO employees TABLE
INSERT INTO tbl_employees VALUES ('Kamal','Hossen',1,'19967765434434567',1000,'1996/09/07','01754465768','Nilgor Sawls 1245',1205,'Dhaka')
INSERT INTO tbl_employees VALUES ('Rohima','Korim',2,'19977765434434567',1001,'1997/09/07','01765434567','Kazi para 1254',1234,'Dhaka')
INSERT INTO tbl_employees VALUES ('Sahid','Miya',1,'19777765434433432',1002,'1977/06/04','01734332345','Kazi para 1254',1234,'Dhaka')
INSERT INTO tbl_employees VALUES ('Harun','Miya',1,'19877654344334567',1003,'1987/04/05','01712332345','Kola bagan 1209',1254,'Dhaka')
INSERT INTO tbl_employees VALUES ('Jamal','Miya',1,'19857654344334567',1002,'1985/04/05','01892332345','Kola bagan 1209',1254,'Dhaka')
GO

--DATA INSERTING  TO Member TABLE
INSERT INTO tbl_Member VALUES ('Arif','Sams','Hossen',1,'01754465768','Nilgor Sawls 1245',1206,'Dhaka','2020/09/09')
INSERT INTO tbl_Member VALUES ('Harun',null,'Hossen',1,'01723223245','Nilgor Sawls 1245',1206,'Dhaka',getdate())
INSERT INTO tbl_Member VALUES ('Hafsa','Begum','Mondol',2,'01723443456','Nilgor Sawls 1245',1206,'Dhaka',getdate())
INSERT INTO tbl_Member VALUES ('Jamal',null,'Hossen',1,'01723223456','Nilgor Sawls 1245',1203,'Dhaka',getdate())
INSERT INTO tbl_Member VALUES ('Rohima',null,'Begum',2,'01721223456','Nilgor Sawls 1222',1222,'Dhaka',getdate())
GO

--DATA INSERTING TO tbl_Tranjection TABLE
INSERT INTO tbl_Tranjection VALUES 
(10001,1,GETDATE(),DEFAULT),
(10002,1,GETDATE(),DEFAULT),
(10003,1,GETDATE(),DEFAULT),
(10004,1,GETDATE(),DEFAULT),
(10003,2,GETDATE(),DEFAULT),
(10002,3,GETDATE(),DEFAULT),
(10001,2,GETDATE(),DEFAULT),
(10003,3,GETDATE(),DEFAULT)
GO
--DATA INSERTING TO tbl_Tranjection TABLE
INSERT INTO tbl_Fine VALUES
(1,10000001,100,'Paid'),
(2,10000002,100,'Paid'),
(3,10000003,100,'Paid'),
(4,10000001,100,'Paid'),
(5,10000001,100,'Paid'),
(6,10000004,100,'Paid'),
(7,10000002,100,'Unpide'),
(8,10000001,100,'Unpide')
GO

INSERT INTO tbl_Fine VALUES(9,10000005,500,'Unpaid')
INSERT INTO tbl_Fine VALUES(10,10000008,500,'Unpaid')
INSERT INTO tbl_Fine VALUES(11,10000006,500,'Unpaid')
INSERT INTO tbl_Fine VALUES(12,10000007,500,'Unpaid')
GO

--STORED PROCEDURE FOR INSERTING DATA TO Category TABLE 

CREATE PROCEDURE spInsertCategory
				 @designation VARCHAR(30)
AS
BEGIN
	INSERT INTO tbl_Genre VALUES(@designation)
END
GO

EXEC spInsertCategory 'TEXT BOOK'
EXEC spInsertCategory 'History of Magic'
EXEC spInsertCategory 'Classics'
EXEC spInsertCategory 'Fantasy'
EXEC spInsertCategory 'Historical Fiction'
EXEC spInsertCategory 'Horror'
EXEC spInsertCategory 'Literary Fiction'
GO

--STORED PROCEDURE FOR INSERTING DATA TO Author TABLE 
CREATE PROC SP_insertingDataAuthor 
			@AuthorName NVARCHAR (40)
AS
BEGIN
	INSERT INTO tbl_Author VALUES (@AuthorName)
END
GO

EXEC SP_insertingDataAuthor 'Hasan Azizul Huq'
EXEC SP_insertingDataAuthor 'Hason Raja'
EXEC SP_insertingDataAuthor 'Hosne Ara Shahed'
EXEC SP_insertingDataAuthor 'Jafro Iqubal'
EXEC SP_insertingDataAuthor 'Humion Ahmed'
EXEC SP_insertingDataAuthor 'Begum Rokea'
GO
--STOR PROC DATA INSERT INOT tbl_Books TABLE

CREATE PROC SP_DataInsertBooksTable
				@publicationID INT,
				@authorID INT,
				@CatagoryID INT,
				@BooksName VARCHAR(34),
				@bDataEntry DATE,
				@bCopy INT
AS
BEGIN
	INSERT INTO tbl_Books VALUES 
(	
	@publicationID,
	@authorID,
	@CatagoryID,
	@BooksName,
	@bDataEntry,
	@bCopy
)
END
GO

EXEC SP_DataInsertBooksTable 1,1,1,'sajer Bati','2020/04/05',9
EXEC SP_DataInsertBooksTable 1,2,1,'Rovin Hood','2019/08/01',12
EXEC SP_DataInsertBooksTable 2,3,1,'Kajar Maze','2022/09/04',5
EXEC SP_DataInsertBooksTable 3,5,1,'Sopno Amar','2018/06/08',56
EXEC SP_DataInsertBooksTable 2,4,1,'Fuler Bati','2000/04/09',87
EXEC SP_DataInsertBooksTable 1,7,1,'Kajer Gor','2020/03/03',123
EXEC SP_DataInsertBooksTable 5,9,1,'Nam jana','2017/03/02',9
EXEC SP_DataInsertBooksTable 1,1,1,'Ratr Basi','2023/03/03',23
EXEC SP_DataInsertBooksTable 4,9,1,'Sraboner Din','1994/03/01',12
EXEC SP_DataInsertBooksTable 1,1,1,'Mon Gora','1990/03/05',9
EXEC SP_DataInsertBooksTable 3,4,1,'Kajol Gora','2012/03/05',3
EXEC SP_DataInsertBooksTable 1,1,1,'Kaje Saje','2017/03/03',5
EXEC SP_DataInsertBooksTable 2,3,1,'Aker modde sat','2023/03/05',9
EXEC SP_DataInsertBooksTable 1,8,1,'Ader Alo','2012/03/04',2
EXEC SP_DataInsertBooksTable 2,9,1,'Jana Kotha','2011/03/05',45
EXEC SP_DataInsertBooksTable 1,1,1,'Moner Aral','2012/03/03',56
EXEC SP_DataInsertBooksTable 1,1,1,'Akta Kotha','2020/03/04',67
EXEC SP_DataInsertBooksTable 2,3,1,'Kaj o'' Kormo','2020/03/03',89
EXEC SP_DataInsertBooksTable 1,5,1,'Mon Bati','2010/03/05',90
EXEC SP_DataInsertBooksTable 1,1,1,'Baloker Kotha','2013/03/05',9
EXEC SP_DataInsertBooksTable 4,7,1,'Bangal Vasa','2016/03/05',78
EXEC SP_DataInsertBooksTable 5,1,1,'Sat Yeari','2016/03/05',98
EXEC SP_DataInsertBooksTable 2,1,1,'Chaka Bati','2012/03/05',34
EXEC SP_DataInsertBooksTable 1,4,1,'Mon Vola','2014/03/05',22
GO

--STOR PROC DATA Delete From tbl_Books TABLE
CREATE PROCEDURE spDeleteBooksData
				 @id int
AS
BEGIN
	DELETE FROM tbl_Books WHERE bookID=@id
END
GO

--STOR PROC DATA Update From tbl_Genre TABLE

CREATE PROCEDURE spUpdateCategory
					@catagoryID INT,
					@CategoryName VARCHAR(40)

AS
BEGIN
	UPDATE tbl_Genre SET catagoryName=@CategoryName WHERE catagoryID=@catagoryID
END
GO
--View Create for allNameData

CREATE VIEW VI_allNameOfData
AS
SELECT bo.bookID,pu.publicationID,au.authorID,ca.catagoryID,bo.bName,bo.bCopy,pu.publicationName,au.authorName,ca.catagoryName FROM tbl_Books bo 
full JOIN tbl_Publication pu ON bo.publicationID=pu.publicationID
full JOIN tbl_Author au ON au.authorID=bo.authorID
right outer JOIN tbl_Genre ca ON ca.catagoryID=bo.catagoryID
full join tbl_Tranjection tr ON tr.bookID=bo.bookID
full JOIN tbl_Member me ON me.memberID=tr.memberID
left JOIN tbl_employees em ON em.genderID=me.genderID
Go

--View Create for BookNameAuthorName

CREATE VIEW vi_BookNameAuthorName
AS
SELECT bo.bName,au.authorName FROM tbl_Books bo
INNER JOIN tbl_Author au ON bo.authorID=au.authorID
GO

--RISTRICT GENDER TABLE FROM MODIFYING
CREATE TRIGGER tr_LockGenderTable
	ON tbl_gender

	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify this table!'
	ROLLBACK TRANSACTION
GO

--Function for tranjection to fine
CREATE FUNCTION fnTranjectionFine
(
   @tranjectionID INT
)
RETURNS TABLE
AS 
RETURN
(
	SELECT fi.* FROM tbl_fine fi
	INNER JOIN tbl_Tranjection tr ON tr.tranjectionID=fi.tranjectionID
	WHERE fi.tranjectionID=@tranjectionID
)
GO

--Vartual Table Create on CatagoryNAme
SELECT  catagoryName INTO CnamePart FROM tbl_Genre

--CREATE INDEX
CREATE INDEX Books
ON tbl_Books(bName)
GO
--function for Fine for books late delivery
CREATE FUNCTION fnbookslatedelivery
(
    @fine INT
)
RETURNS @fnbookslatedelivery TABLE 
(
	fineID INT,
	tranjectionID BIGINT,
	fineAmount MONEY,
	fstatus CHAR (10)
)
AS
BEGIN
		INSERT @fnbookslatedelivery
		SELECT fineID,tranjectionID,fineAmount,fstatus FROM tbl_Fine
		WHERE fineID=@fine
		RETURN 
END
GO

