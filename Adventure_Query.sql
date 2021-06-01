/*Use AdventureWorks2008R2 database*/
USE [AdventureWorks2008R2]
GO

/*Data Exploration*/
/*Determine top 10 Ordered Products by Revenue*/
SELECT TOP 10 SOD.ProductID, 
				PP.Name, 
				SUM(SOD.OrderQty) AS Order_Total,
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

/*Determine top 10 Categories*/
SELECT *
FROM Production.Product