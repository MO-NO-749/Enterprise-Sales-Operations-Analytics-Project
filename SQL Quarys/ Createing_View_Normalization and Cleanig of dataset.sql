

-- Normalizing & Cleaning Transactions dataset

-- Creating view table Order

CREATE VIEW [Orders] AS
  SELECT DISTINCT [OrderNumber]
      ,[OrderDate]
      ,[DeliveryDate]
      ,CASE WHEN [DeliveryDate] IS NULL THEN 'NOT Delivered'
            ELSE 'Delivered' END AS Delivary_Status
      ,[CustomerID]
      ,[StoreID]
  FROM Transactions

-- Creating view table Order_Line_Items

CREATE VIEW [Order_Line_Items] AS
  SELECT DISTINCT [TransactionID]
      ,[OrderNumber]
      ,[LineItem]
      ,[Quantity]
      ,[ProductID]
  FROM Transactions

   
-- Creating view table Stores

  CREATE VIEW Stores AS 
  SELECT DISTINCT [StoreID]
      ,[StoreCountry]
      ,[StoreState]
      ,[StoreSqMeters]
      ,[StoreOpenDate]
  FROM Transactions


-- Creating view table Customers

  CREATE VIEW Customers AS 
  SELECT DISTINCT [CustomerID]
      ,[CustomerGender]
      ,[CustomerName]
      ,[CustomerCity]
      ,[CustomerStateCode]
      ,[CustomerState]
      ,[CustomerZip]
      ,[CustomerCountry]
      ,[CustomerContinent]
      ,[CustomerDOB]
  FROM Transactions


-- Creating view table Products

  CREATE VIEW Products AS 
  SELECT DISTINCT  [ProductID]
      ,[ProductName]
      ,[ProductBrand]
      ,[ProductColor]
      ,[ProductCost]
      ,[ProductPrice]
      ,REPLACE(LEFT(ProductSubcategoryID,5),':','') AS ProductSubcategoryID
  FROM Transactions

-- Creating view table Store_Product_Relation 

   CREATE VIEW Stores AS 
   SELECT DISTINCT [StoreID]
      ,[ProductID]
   FROM Transactions


-- Creating view table product_subcatagory
  
  CREATE VIEW product_subcatagory AS 
  SELECT DISTINCT REPLACE(LEFT(ProductSubcategoryID,5),':','') AS ProductSubcategoryID
      ,[ProductSubcategory]
      ,[ProductCategoryID]
  FROM Transactions

  
-- Creating view table Product_Category
  
  CREATE VIEW Product_Category AS
  SELECT DISTINCT [ProductCategoryID]
      ,[ProductCategory]
  FROM Transactions
