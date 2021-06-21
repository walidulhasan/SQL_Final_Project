USE ISPDB
GO

--INSERTING INTO CUSTOMER TYPE TABLE 

INSERT INTO customerType VALUES 
(1, 'General'),
(2, 'Corporate')
GO

SELECT * FROM customerType
GO

--INSERTING INTO PAYMENT METHOD TABLE

INSERT INTO paymentMethod VALUES 
(1, 'Cash'),
(2, 'bKash'),
(3, 'Rocket'),
(4, 'Card')
GO

SELECT * FROM paymentMethod
GO

--INSERTING INTO EMPLOYEE TYPE TABLE 

INSERT INTO employeeType VALUES 
(1, 'General'),
(2, 'Service Provider')
GO

SELECT * FROM employeeType
GO

--INSERTING INTO OFFICE ADDRESS TABLE

INSERT INTO officeAddress VALUES 
(1, '27/3 KA Dhakeswari Road Lalbagh, Dhaka-1211'),
(2, '10/3/A R.N.D Road Dhaka-1205'),
(3, '25/A B.C Das Street New Market Dhaka'),
(4, '7/B Mohammadpur Dhaka-1100 ')
GO

SELECT * FROM officeAddress
GO

--INSERTING INTO AREA TABLE 

INSERT INTO serviceArea VALUES 
(1, 'Lalbagh', 1),
(2, 'Islambagh', 1),
(3, 'Hazaribagh', 1),
(4, 'Kamrangirchar', 2),
(5, 'Nawabgonj', 2),
(6, 'Shahid Nagar', 2),
(7, 'New Market', 3),
(8, 'Fooler Road', 3),
(9, 'TSC', 3),
(10, 'Mohammadpur', 4),
(11, 'Jigatola', 4),
(12, 'Shankar', 4)
GO

SELECT * FROM serviceArea
GO

--EXECUTING STORED PROCEDURE FOR INSERTING INTO PACKAGE PLAN TABLE 

EXEC spInsertIntoPackagePlan 'Unlimited Package-1', '5 Mbps', 600
EXEC spInsertIntoPackagePlan 'Unlimited Package-2', '6 Mbps', 700
EXEC spInsertIntoPackagePlan 'Unlimited Package-3', '7 Mbps', 800
EXEC spInsertIntoPackagePlan 'Unlimited Package-4', '10 Mbps', 1000
EXEC spInsertIntoPackagePlan 'Unlimited Package-5', '12 Mbps', 1200
EXEC spInsertIntoPackagePlan 'Unlimited Package-6', '15 Mbps', 1500
EXEC spInsertIntoPackagePlan 'Unlimited Package-7', '20 Mbps', 2000
EXEC spInsertIntoPackagePlan 'Unlimited Package-8', '25 Mbps', 2500
EXEC spInsertIntoPackagePlan 'Corporate Package-1', '50 Mbps', 3000
EXEC spInsertIntoPackagePlan 'Corporate Package-2', '100 Mbps', 5000
EXEC spInsertIntoPackagePlan 'Corporate Package-3', '200 Mbps', 10000
EXEC spInsertIntoPackagePlan 'Advance-1(20 Hour)', '20 Mbps', 1000
EXEC spInsertIntoPackagePlan 'Advance-2(20 Hour)', '30 Mbps', 1500
EXEC spInsertIntoPackagePlan 'Advance-3(20 Hour)', '40 Mbps', 2000
EXEC spInsertIntoPackagePlan 'Advance-4(4 Hour)', '10 Mbps', 1000
EXEC spInsertIntoPackagePlan 'Advance-5(4 Hour)', '15 Mbps', 1500
EXEC spInsertIntoPackagePlan 'Advance-6(4 Hour)', '20 Mbps', 2000
GO

SELECT * FROM pacKagePlan
GO

--EXECUTING STORED PROCEDURE FOR INSERTING INTO EMPLOYEE TABLE 

EXEC spInsertIntoEmployee 1, 'MD. Rakib', 'Hasan', '+8801515613231', 'rakib24@gmail.com', '1995/02/20', 1995654231, 'Mohammadpur', 1210, 1, 1
EXEC spInsertIntoEmployee 2, 'Neyamot', 'Ullah', '+8801858859482', 'neyamot101@gmail.com', '1995/05/02', 1995050210, 'Jigatola', 1000, 1, 2
EXEC spInsertIntoEmployee 3, 'Sujan', 'Mahmud', '+8801715759871', 'sujan@gmail.com', '1994/02/02', 1994020265, 'Jatrabari', 1300, 2, 1
EXEC spInsertIntoEmployee 4, 'Manik', 'Mia', '+8801935394335', 'manik@gmail.com', '1990/02/20', 1990022012, 'Basabo', 1100, 2, 2
EXEC spInsertIntoEmployee 5, 'MD. Rayhan', 'Hossain', '+8801521449144', 'rayhan24@gmail.com', '1995/12/20', 1995122032, 'Lalbagh', 1211, 1, 3
EXEC spInsertIntoEmployee 6, 'Rejwanur', 'Rahman', '+8801759846125', 'rejwan365@gmail.com', '1992/03/20', 1992032010, 'Mirpur-1', 1150, 1, 3
EXEC spInsertIntoEmployee 7, 'Jisan', 'Mahmud', '+8801854561253', 'jisan@gmail.com', '1996/12/12', 1996121202, 'Agargaon', 1050, 2, 3
EXEC spInsertIntoEmployee 8, 'Shamim', 'Hasan', '+8801554235972', 'shamim@gmail.com', '1990/02/20', 1990022013, 'Basabo', 1100, 1, 4
EXEC spInsertIntoEmployee 9, 'Prema', 'Shahriar', '+8801758946514', 'premash@gmail.com', '1992/10/30', 1992103012, 'Tejgaon', 1000, 1, 4
EXEC spInsertIntoEmployee 10, 'Ruma', 'Kabir', '+8801984513254', 'kruma108@gmail.com', '1994/10/30', 1994103021, 'Farmgate', 1150, 1, 4
GO

SELECT * FROM employee
GO

--EXECUTING STORED PROCEDURE FOR INSERTING INTO CUSTOMER TABLE 

EXEC spInsertIntoCustomer 'Abdur', 'Rahman', '+8801784512568', 'Lalbagh', 1211, 'abdurrahman@gmail.com', 246, '2020/01/01', 1, 1, 1, 1
EXEC spInsertIntoCustomer 'Saydur', 'Rahman', '+8801845974512', 'Islambagh', 1215, 'sayed@gmail.com', 250, '2020/03/01', 2, 1, 2, 2
EXEC spInsertIntoCustomer 'Jibon', 'Mahmud', '+8801557898415', 'Hazaribagh', 1250, 'jibon@gmail.com', 850, '2019/10/01', 9, 2, 4, 3
EXEC spInsertIntoCustomer 'Hasan', 'Ali', '+8801798412356', 'Kamrangirchar', 1100, 'ali25@gmail.com', 125, '2018/12/01', 3, 1, 1, 4
EXEC spInsertIntoCustomer 'Saikat', 'Rayhan', '+8801874514563', 'Nawabgonj', 1150, 'saikat@gmail.com', 1000, '2020/06/01', 4, 1, 2, 5
EXEC spInsertIntoCustomer 'Raju', 'Hasan', '+8801845631254', 'New Market', 1205, 'raju@gmail.com', 190, '2020/04/01', 7, 1, 4, 7
EXEC spInsertIntoCustomer 'Rahaduzzaman', 'Rajib', '+8801984561235', 'Flooer Road', 1205, 'rajib365@gmail.com', 701, '2019/04/01', 10, 2, 4, 8
EXEC spInsertIntoCustomer 'Nayeem', 'Hasan', '+8801784123654', 'Mohammadpur', 1300, 'nayeem@gmail.com', 750, '2018/11/01', 8, 1, 1, 10
EXEC spInsertIntoCustomer 'Jahurul', 'Haq', '+8801874326584', 'Jigatola', 1250, 'haq@gmail.com', 188, '2020/07/01', 11, 2, 4, 11
EXEC spInsertIntoCustomer 'Sunny', 'Rahman', '+8801897132046', 'Shankar', 1350, 'sunny@gmail.com', 1010, '2018/05/01', 13, 1, 1, 12
EXEC spInsertIntoCustomer 'Basidur', 'Rahman', '+8801796412563', 'Mohammadpur', 1300, 'basid@gmail.com', 299, '2019/02/01', 17, 1, 3, 10
EXEC spInsertIntoCustomer 'Jubaer', 'Mahumd', '+8801984563145', 'Lalbagh', 1211, 'jubaer@gmail.com', 399, '2019/11/01', 5, 1, 1, 1
GO

SELECT * FROM customer
GO

-- EXECUTING STORED PROCEDURE FOR UPDATING CUSTOMER TABLE

EXEC spUpdateToCustomer 'Kamrul', 'Hasan', 'Islambagh', 1215, 2, 299
GO

SELECT * FROM customer
GO

--EXECUTING STORED PROCEDURE FOR DELETING FROM CUSTOMER

EXEC spDeleteFromCustomer 399
GO

SELECT * FROM customer
GO

--EXECUTING STORED PROCEDURE WITH RETURN VALUE

DECLARE @ID INT
	EXEC @ID=spInsertIntoCustomerWithReturn 'Al', 'Mamun', '+8801894125432', 'Kamrangirchar', 1210, 'mamun@gmail.com', 400, '2020/08/01', 5, 1, 3, 4
	PRINT 'NEW CUSTOMERID INSERTED: ' + STR(@ID)
GO

--EXECUTING SCALAR FUNCTION FOR EMPLOYEE TABLE

SELECT dbo.fnCountServiceProviderFromEmployee(2) AS Total_Count
GO

--EXECUTING TABLE-VALUED FUNCTION FOR EMPLOYEE TABLE

SELECT * FROM dbo.fnListOfServiceProvider(2)
GO

--EXECUTING TABLE-VALUED FUNCTION

SELECT * FROM dbo.fnAreaWisePriceSum('Lalbagh')
GO

--JOIN QUERY

SELECT c.customerFirstName, c.customerLastName, ct.customerTypeName,c.IPNumber, pp.planName, pp.price, sa.ServiceAreaName, pm.paymentMethodName 
FROM paymentMethod pm
INNER JOIN customer c ON pm.paymentMethodID=c.paymentMethodID
INNER JOIN customerType ct ON c.customerTypeID=ct.customerTypeID
INNER JOIN pacKagePlan pp ON c.planID=pp.planID
INNER JOIN serviceArea sa ON c.ServiceAreaID=sa.ServiceAreaID
WHERE PM.paymentMethodName='bKash'
GO

--SUBQUERY

SELECT planID, planName FROM pacKagePlan 
WHERE planID NOT IN (SELECT planID FROM customer)
GO

--CTE

WITH customerList AS
(
SELECT c.customerFirstName, c.customerLastName, c.IPNumber, pm.paymentmethodName, c.connectionStartDate 
FROM customer c
INNER JOIN paymentMethod pm ON c.paymentmethodID=pm.paymentmethodID
WHERE pm.paymentmethodName IN('Cash', 'bKash')
)
SELECT * FROM customerList
WHERE connectionStartDate >= '2019/01/01'
GO

--CTE 2

WITH areaCount AS
(
SELECT c.ServiceAreaID,sa.ServiceAreaName, COUNT(c.ServiceAreaID) AS TotalArea FROM customer c
INNER JOIN serviceArea sa ON c.ServiceAreaID=sa.ServiceAreaID
GROUP BY c.ServiceAreaID, sa.ServiceAreaName
)
SELECT AVG(TotalArea) AS avgerageCustomerbyArea FROM areaCount
GO

--EXECUTING VIEW

SELECT * FROM vCorporateCustomer
GO

--EXECUTING TRIGGER ON PACKAGE PLAN TABLE (AFTER TRIGGER)

INSERT INTO pacKagePlan VALUES 
('SPECIAL PLAN-2', '10 MBPS', 500)

SELECT * FROM pacKagePlan
GO

--EXECUTING TRIGGER ON CUSTOMER TYPE TABLE (INSTEAD OF TRIGGER)

INSERT INTO customerType VALUES 
(3, NULL)

SELECT * FROM customerType
GO

--EXECUTING TRIGGER ON EMPLOYEE TABLE (INSTEAD OF TRIGGER)

DELETE FROM employee
WHERE employeeID=10

SELECT * FROM employee
GO















