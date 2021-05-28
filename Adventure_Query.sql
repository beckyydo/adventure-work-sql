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

