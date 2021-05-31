/*Use AdventureWorks2008R2 database*/
USE [AdventureWorks2008R2]
GO

/*All Employee With Job Title Is 'Research and Development Engineer'*/
SELECT BusinessEntityID, LoginID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle = 'Research and Development Engineer'
GO

/*All people whose rows were modified during Februray 2001*/
SELECT BusinessEntityID, FirstName, LastName, ModifiedDate
FROM Person.Person
WHERE ModifiedDate >= '2001-02-01' 
AND ModifiedDate < '2001-03-01'
GO

/*Retrieve orders during September 2005 and total due exceed $1000*/
/*Option 1*/
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2005-07-01' AND '2005-07-31'
AND TotalDue > 1000

/*Option 2*/
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2005-07-01' AND  OrderDate <='2005-07-31'
AND TotalDue > 1000

/*Explore Data in Table*/
SELECT TOP 10 *
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43659 
AND ProductID = 776

SELECT *
FROM Production.Product
WHERE ProductID = 776

SELECT *
FROM Production.ProductCostHistory
WHERE ProductID = 776