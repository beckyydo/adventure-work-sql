/*****************USE AdventureWorks2008R2 DATABASE*****************/
USE [AdventureWorks2008R2]
GO

/*************************DATA EXPLORATION*************************/
/*Determine TOP 10 Ordered Products by Revenue*/
SELECT TOP 10 SOD.ProductID
			, PP.Name
			, SUM(SOD.OrderQty) AS 'Total Order QTY'
			, CAST(ROUND( SUM(SOD.LineTotal), 2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
GROUP BY SOD.ProductID
		, PP.Name
ORDER BY Total DESC
GO
/*From the table, Mountain-200 Black, 38 is the top item. Variations of the same items
appear to be on the top 10 list followed by Road-250*/

/*Determine TOP 10 Sub Categories*/
SELECT TOP 10 PP.ProductSubcategoryID
			, PPS.Name AS Subcategory
			, PPC.ProductCategoryID
			, PPC.Name AS Category
			, SUM(SOD.OrderQty) AS TtlQTY
			, CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
LEFT JOIN Production.ProductSubcategory AS PPS
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PPC
	ON PPS.ProductCategoryID = PPC.ProductCategoryID
GROUP BY PP.ProductSubcategoryID
	, PPS.Name
	, PPC.ProductCategoryID
	, PPC.Name
ORDER BY Total DESC
GO
/*From the table, Road Bikes and Mountain Bikes are the top subcategories 
base on the revenue total*/

/*Determine TOP 10 Categories*/
SELECT TOP 10 PPC.ProductCategoryID
			, PPC.Name AS Category
			, SUM(SOD.OrderQty) AS TotalQTY
			, CAST(ROUND(SUM(SOD.LineTotal),2) AS FLOAT) as Total
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Production.Product as PP 
	ON SOD.ProductID = PP.ProductID
LEFT JOIN Production.ProductSubcategory AS PPS
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PPC
	ON PPS.ProductCategoryID = PPC.ProductCategoryID
GROUP BY PPC.ProductCategoryID
	, PPC.Name
ORDER BY Total DESC
GO
/*There are only 4 categories total for the table, the top category being Bikes based
on revenue*/

/*Check Sales in All Countries*/
SELECT PCR.Name
	, PSP.CountryRegionCode
	, '$ ' + CONVERT(VARCHAR,SUM(SOH.TotalDue)) AS Total
	, COUNT(SOH.TotalDue) AS NumOrders
FROM Sales.SalesOrderHeader AS SOH
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
LEFT JOIN Person.CountryRegion as PCR
	ON PSP.CountryRegionCode = PCR.CountryRegionCode
GROUP BY PCR.Name
	, PSP.CountryRegionCode
ORDER BY SUM(SOH.TotalDue) DESC
GO
/*From this table, United States has the most sales and orders with Canada as second in Sales*/

/*CANADA SALE EXPLORATION*/
/*Determine Number of Orders and Sales $ by Province/Territory*/
SELECT PSP.Name
	, CAST(ROUND(SUM(SOH.TotalDue),2) AS FLOAT) AS Total$
	, COUNT(PSP.Name) AS NumOrders
	, CAST(ROUND(SUM(SOH.TotalDue)/COUNT(PSP.Name),2) AS FLOAT) AS SalesPerOrder
FROM Sales.SalesOrderHeader AS SOH
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
WHERE PSP.CountryRegionCode = 'CA'
GROUP BY PSP.Name
ORDER BY Total$ DESC
GO
/*From our examination of the Canadian orders, we see that for Ontario orders have the highest sales $ 
but compared to British Columbia who is a close second in sales $, Ontario is able to get to their total 
with a lot less order compared to British Columbia. The $ spent per order for Ontario is about $19,000 more*/

/*Next we'll examine why the above case is true by exploring products & unit price sold under ONT & BC*/
WITH ORDER_LIST AS (
SELECT SOD.SalesOrderID
	, PSP.Name
	, COUNT(DISTINCT SOD.ProductID) AS Num_Products
	, SUM(SOD.OrderQty) AS TotalQTY
	, SUM(SOD.LineTotal) AS Total$
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
WHERE PSP.CountryRegionCode = 'CA'
	AND PSP.Name IN ('Ontario','British Columbia')
GROUP BY SOD.SalesOrderID
	, PSP.Name
)
SELECT Name
	, AVG(Num_Products) AS AvgProducts
	, AVG(TotalQTY) AS AvgQTY
FROM ORDER_LIST
GROUP BY Name
GO
/*From this table you can see that on average Ontario orders have signifcantly more different products and
total order quantity than British Columbia. It seem that most of the orders being placed in British Columbia
are very small*/

/*Explore QTY Distribution for Ontario*/
WITH ONT_RANGE AS (
SELECT SOD.SalesOrderID
			, SUM(SOD.OrderQty) AS TotalQTY
			, CASE 
				WHEN SUM(SOD.OrderQTY) < 10 THEN '<10'		
				WHEN SUM(SOD.OrderQTY) BETWEEN 10 AND 19 THEN '10-19'		
				WHEN SUM(SOD.OrderQTY) BETWEEN 20 AND 29 THEN '20-29'	
				WHEN SUM(SOD.OrderQTY) BETWEEN 30 AND 39 THEN '30-39'
				WHEN SUM(SOD.OrderQTY) BETWEEN 40 AND 49 THEN '40-49'
				ELSE '>50' END AS QTYRange
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Sales.SalesOrderHeader AS SOH 
	ON SOD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
LEFT JOIN Production.Product AS PP 
	ON SOD.ProductID = PP.ProductID
WHERE PSP.CountryRegionCode = 'CA'
	AND PSP.Name = 'Ontario'
GROUP BY SOD.SalesOrderID
)
SELECT QTYRange
	, COUNT(QTYRange) AS NumOrders
	, CONVERT(FLOAT, ROUND(COUNT(QTYRange)*100.0/SUM(COUNT(QTYRange)) Over(),2)) AS Percentage
FROM ONT_RANGE
GROUP BY QTYRange
GO

WITH BC_RANGE AS (
SELECT SOD.SalesOrderID
			, SUM(SOD.OrderQty) AS TotalQTY
			, CASE 
				WHEN SUM(SOD.OrderQTY) < 10 THEN '<10'		
				WHEN SUM(SOD.OrderQTY) BETWEEN 10 AND 19 THEN '10-19'		
				WHEN SUM(SOD.OrderQTY) BETWEEN 20 AND 29 THEN '20-29'	
				WHEN SUM(SOD.OrderQTY) BETWEEN 30 AND 39 THEN '30-39'
				WHEN SUM(SOD.OrderQTY) BETWEEN 40 AND 49 THEN '40-49'
				ELSE '>50' END AS QTYRange
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Sales.SalesOrderHeader AS SOH 
	ON SOD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
LEFT JOIN Production.Product AS PP 
	ON SOD.ProductID = PP.ProductID
WHERE PSP.CountryRegionCode = 'CA'
	AND PSP.Name = 'British Columbia'
GROUP BY SOD.SalesOrderID
)
SELECT QTYRange
	, COUNT(QTYRange) AS NumOrders
	, CONVERT(FLOAT, ROUND(COUNT(QTYRange)*100.0/SUM(COUNT(QTYRange)) Over(),2)) AS Percentage
FROM BC_RANGE
GROUP BY QTYRange
GO
/*From the two tables, a large percentage of orders in Ontario have a QTY > 50 or < 10 where as in BC majority of the orders are < 10 at 
about 98%. The large orders in Ontario may be due to business buying inventory to sell where as majority of BC customers are buying for themselves*/

/*Top 10 Products for Ontario*/
SELECT TOP 10 SOD.ProductID
			, PP.Name
			, SUM(SOD.UnitPrice) AS Total$
			, SUM(SOD.OrderQty) AS TotalQTY
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Sales.SalesOrderHeader AS SOH 
	ON SOD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
LEFT JOIN Production.Product AS PP 
	ON SOD.ProductID = PP.ProductID
WHERE PSP.CountryRegionCode = 'CA'
	AND PSP.Name = 'Ontario'
GROUP BY SOD.ProductID
		, PP.Name
ORDER BY Total$ DESC
GO
/*Top 2 item for Ontario is the Mountain-200 Black*/

/*Top 10 Products for British Columbia*/
SELECT TOP 10 SOD.ProductID
			, PP.Name
			, SUM(SOD.UnitPrice) AS Total$
			, SUM(SOD.OrderQty) AS TotalQTY
FROM Sales.SalesOrderDetail AS SOD
LEFT JOIN Sales.SalesOrderHeader AS SOH 
	ON SOD.SalesOrderID = SOH.SalesOrderID
LEFT JOIN Person.Address AS PA
	ON SOH.ShipToAddressID = PA.AddressID
LEFT JOIN Person.StateProvince AS PSP
	ON PA.StateProvinceID = PSP.StateProvinceID
LEFT JOIN Production.Product AS PP ON SOD.ProductID = PP.ProductID
WHERE PSP.CountryRegionCode = 'CA'
	AND PSP.Name = 'British Columbia'
GROUP BY SOD.ProductID,
			PP.Name
ORDER BY Total$ DESC
GO
/*Top 2 item for BC is the Mountain-200 Black and the Road-150*/

