CREATE TABLE purchase
(
	purchaseID INT IDENTITY PRIMARY KEY,
	supplierID INT REFERENCES suppliers(supplierID),
	purchaseDate DATETIME DEFAULT GETDATE(),
	grossPrice MONEY,
	discountRate FLOAT,
	discount MONEY AS grossPrice*discountRate,
	netPay AS grossPrice-(grossPrice*discountRate)
)
GO

CREATE TABLE purchaseDetails
(
	purchaseID INT REFERENCES purchase(purchaseID),
	productID INT REFERENCES products(productID),
	quantity INT NOT NULL CHECK(quantity>0),
	price MONEY,
	amount AS quantity*price,
	PRIMARY KEY(purchaseID,productID)
)
GO





--STORED PROCEDURE FOR INSERTING DATA TO PURCHASE TABLE 

CREATE PROCEDURE spInsertPurchase
						@supplierID INT,
						@discountRate FLOAT

AS
BEGIN
	INSERT INTO purchase(supplierID,purchaseDate,discountRate) VALUES
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
	SELECT @price=purchasePrice FROM products WHERE productID=@productID
	INSERT INTO purchaseDetails(purchaseID,productID,quantity,price) VALUES
			(@purchaseID,@productID,@quantity,@price)
END
GO

--TRIGGER FOR AOUTOMATIC UPDATE PURCHASE AND STOCK TABLE



CREATE TRIGGER trAddproductToPurchase
    ON purchaseDetails
    AFTER INSERT
	AS
    BEGIN
	--UPDATING STOCK
		DECLARE @quantity INT;
		DECLARE @productID INT;
		SELECT @productID=productID FROM inserted
		SELECT @quantity=quantity FROM inserted
		UPDATE stock
		SET quantity=quantity+@quantity
		WHERE productID=@productID
	--UPDATING PURCHASE
		DECLARE @grossAmount MONEY;
		DECLARE @ID INT;
		SELECT @ID=purchaseID FROM inserted
		SELECT @grossAmount=SUM(amount)  FROM purchaseDetails WHERE purchaseID=@ID
		UPDATE purchase
		SET grossPrice=@grossAmount
		WHERE purchaseID=@ID
    END
GO


--PREVENTING DELETATION FROM SALES TABLE
CREATE TRIGGER trRistrictDeleteFrompurchase
ON purchase
FOR DELETE
AS
BEGIN
 ROLLBACK TRANSACTION
 PRINT 'Data cannot be deleted from purchase record'
END
GO
