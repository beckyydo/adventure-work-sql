/*****************USE AdventureWorks2008R2 DATABASE*****************/
USE [AdventureWorks2008R2]
GO

/*************************DATA EXPLORATION*************************/
/*Determine TOP 10 Ordered Products by Revenue*/
SELECT TOP 10 SOD.ProductID, 
				PP.Name, 
				SUM(SOD.OrderQty) AS 'Total Order QTY',
				CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
GROUP BY SOD.ProductID,	
			PP.Name
ORDER BY Total DESC
GO
/*From the table, Mountain-200 Black, 38 is the top item. Variations of the same items
appear to be on the top 10 list followed by Road-250*/

/*Determine TOP 10 Sub Categories*/
SELECT TOP 10 PP.ProductSubcategoryID, 
				PPS.Name AS 'Subcat Name',
				PPC.ProductCategoryID,
				PPC.Name AS 'Cat Name',
				SUM(SOD.OrderQty) AS 'Total Order QTY',
				CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
LEFT JOIN Production.ProductSubcategory AS PPS
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PPC
	ON PPS.ProductCategoryID = PPC.ProductCategoryID
GROUP BY PP.ProductSubcategoryID, 
				PPS.Name,
				PPC.ProductCategoryID,
				PPC.Name
ORDER BY Total DESC
GO
/*From the table, Road Bikes and Mountain Bikes are the top subcategories 
base on the revenue total*/

/*Determine TOP 10 Categories*/
SELECT TOP 10 PPC.ProductCategoryID,
				PPC.Name AS 'Cat Name',
				SUM(SOD.OrderQty) AS 'Total Order QTY',
				CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
LEFT JOIN Production.ProductSubcategory AS PPS
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PPC
	ON PPS.ProductCategoryID = PPC.ProductCategoryID
GROUP BY PPC.ProductCategoryID,
			PPC.Name
ORDER BY Total DESC
GO
/*There are only 4 categories total for the table, the top category being Bikes based
on revenue*/

/*Determine TOP 10 Orders Products by Sales Margin*/
SELECT TOP 10 SOD.ProductID, 
				PP.Name, 
				SUM(SOD.OrderQty) AS 'Total Order QTY',
				CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
GROUP BY SOD.ProductID,	
			PP.Name
ORDER BY Total DESC
GO

SELECT *
FROM Sales.SalesOrderDetail

SELECT *
FROM Sales.SalesOrderHeader