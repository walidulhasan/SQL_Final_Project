/*
							------T-SQL Executing File----------
								Library Management System
								-----Creator of Project----
								Walidulhasan Boniamin
								Trainee Id: 1258683
								Batch ID: ESAD-CS/PNTL-A/45/01
						 -----------------------------------------
*/
USE LibraryManagementSystem
GO

-- Data Base all info with Default sp
EXEC SP_HELPDB LibraryManagementSystem
GO

--Quary with Aggregate use without Grouping
SELECT count(fi.fineID) TotalID,sum(fi.fineAmount) AS 'Total Fine' FROM tbl_Books bo
INNER JOIN tbl_Author au On au.authorID=bo.authorID
JOIN tbl_Tranjection tr ON tr.bookID=bo.bookID
JOIN tbl_Fine fi ON fi.tranjectionID=tr.tranjectionID;
GO

--SUBQUARY FOR DATA CALCUALTING VIEW
SELECT fi.tranjectionID,fi.fineID,fi.fineAmount,fi.fstatus FROM tbl_Fine fi
WHERE fi.fineAmount<(SELECT DISTINCT fineAmount FROM tbl_Fine WHERE fineAmount=500)
ORDER BY tranjectionID ASC

--Quary of Fine Table(Show one member total fine)
SELECT Count(*) AS TotalID,sum(fineAmount) AS 'Total Fine' FROM tbl_fine
Where tranjectionID=10000001;
GO

--AGRAGIDE FUNCTION USE 
SELECT  sum(fi.fineAmount) as [sum],
max (fi.fineAmount)as [max],
AVG(fi.fineAmount) as [AVG],
min(fi.fineAmount) as [min]
FROM tbl_Fine fi
GO
--using Having in agragide function with group by
SELECT fi.tranjectionID,sum(fi.fineAmount) as TotalFine from tbl_Fine fi
group by fi.tranjectionID
having sum(fi.fineAmount)>(select distinct fineAmount+100 from tbl_Fine where tranjectionID=10000001)
order by fi.tranjectionID asc

--View Create for ALLofDATA
SELECT * FROM VI_allNameOfData;
GO


--DELETE bOOK TABLE ROWS USING STORED PROCEDURE
EXEC spDeleteBooksData 10

--UPDATE Category TABLE ROWS USING STORED PROCEDURE
EXEC spUpdateCategory 7,'MAGICAL PIE'


-- TRIGGER WITHOUT ENCRIPTION
EXEC sp_helptext tr_LockGenderTable
GO

--VARTUAL TABLE 
SELECT * FROM CnamePart

--function for Fine for books late delivery WITH FEE
SELECT * from fnbookslatedelivery(5)
GO

--Alter table ADD COLAMN
ALTER TABLE tbl_employees
ADD Email varchar(255);

--Alter table DELETE COLAMN
DELETE FROM tbl_employees WHERE employeeID=5
--CTE
WITH Employee_CTE (EmployeeNumber, Title)
AS
(SELECT em.firstName+' '+em.lastName,
        em.contactNo
 FROM   tbl_employees em)
SELECT EmployeeNumber,
       Title
FROM   Employee_CTE
GO