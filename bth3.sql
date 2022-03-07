USE AdventureWorks2019
GO

--Cau 1
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Production.Product

SELECT s1.ProductID,p.Name as Product_Name,COUNT(*) as CountOfOrderID,SUM(s1.OrderQty*s1.UnitPrice) as SubTotal
FROM Sales.SalesOrderDetail s1
JOIN Sales.SalesOrderHeader s2 ON s1.SalesOrderID = s2.SalesOrderID
JOIN Production.Product p ON s1.ProductID = p.ProductID
WHERE (YEAR(s2.OrderDate)=2011) AND (MONTH(s2.OrderDate) BETWEEN 4 AND 6) AND (SubTotal>10000)
GROUP BY s1.ProductID,p.Name
--HAVING COUNT(*) > 500

--Cau 2
SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Person.Person
SELECT * FROM Sales.PersonCreditCard

SELECT a.PersonID,b.FirstName + ' ' + b.LastName AS FullName, COUNT(*) AS CountOfOrders
FROM Sales.Customer a
JOIN Sales.SalesOrderHeader c ON a.CustomerID = c.CustomerID
JOIN Sales.PersonCreditCard d ON c.CreditCardID = d.CreditCardID
JOIN Person.Person b ON b.BusinessEntityID = d.BusinessEntityID
WHERE YEAR(c.OrderDate) BETWEEN 2011 AND 2014
GROUP BY a.PersonID, b.FirstName,b.LastName
HAVING COUNT(*) > 25

--Cau 3
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Production.Product

SELECT p.ProductID,p.Name,SUM(s1.OrderQty) AS CountOfOrderQty, YEAR(s2.OrderDate) as 'Year'
FROM Production.Product p
JOIN Sales.SalesOrderDetail s1 ON p.ProductID = s1.ProductID
JOIN Sales.SalesOrderHeader s2 ON s1.SalesOrderID = s2.SalesOrderID
WHERE p.Name LIKE 'Bike%' OR p.Name LIKE 'Sport%'
GROUP BY p.ProductID,p.Name,s2.OrderDate
HAVING SUM(s1.OrderQty) > 200
ORDER BY CountOfOrderQty DESC

--Cau 4
SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.EmployeePayHistory

SELECT h1.DepartmentID,h1.Name,AVG(h3.Rate) AS AvgOfRate
FROM HumanResources.Department h1
JOIN HumanResources.EmployeeDepartmentHistory h2 ON h1.DepartmentID = h2.DepartmentID
JOIN HumanResources.EmployeePayHistory h3 ON h2.BusinessEntityID = h3.BusinessEntityID
GROUP BY h1.DepartmentID,h1.Name
HAVING AVG(h3.Rate) > 30