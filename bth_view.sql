USE AdventureWorks2019
GO

--Cau 1
CREATE VIEW dbo.vw_Product AS
	SELECT p1.ProductID,p1.Name,p1.Color,p1.Size,p1.Style,p2.StandardCost,p2.StartDate,p2.EndDate
	FROM Production.Product p1
	JOIN Production.ProductCostHistory p2 ON p1.ProductID = p2.ProductID
SELECT * FROM vw_Product

--Cau 2
CREATE VIEW List_Product_View AS
	SELECT s1.ProductID,p.Name,COUNT(s1.SalesOrderID) AS CountOfOrderID, SUM(s1.OrderQty*s1.UnitPrice) as SubTotal
	FROM Sales.SalesOrderDetail s1
	JOIN Sales.SalesOrderHeader s2 ON s1.SalesOrderID = s2.SalesOrderID
	JOIN Production.Product p ON s1.ProductID = p.ProductID
	WHERE YEAR(s2.OrderDate)=2014 AND MONTH(s2.OrderDate) BETWEEN 1 AND 3 AND SubTotal > 10000
	GROUP BY s1.ProductID,p.Name
	HAVING COUNT(s1.SalesOrderID) > 50
SELECT * FROM List_Product_View

--Cau 3
CREATE VIEW dbo.vw_CustomerTotals AS
	SELECT s1.CustomerID,YEAR(s1.OrderDate) AS OrderYear,MONTH(s1.OrderDate) AS OrderMonth,SUM(s1.TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader s1
	GROUP BY s1.CustomerID,s1.OrderDate
SELECT * FROM vw_CustomerTotals
ORDER BY 1

--Cau 4
CREATE VIEW vw_TotalQuantity AS 
	SELECT s1.SalesPersonID,YEAR(s1.OrderDate) AS OrderYear,MONTH(s1.OrderDate) AS OrderMonth,SUM(s2.OrderQty) AS SumOfOrderQty
	FROM Sales.SalesOrderHeader s1
	JOIN Sales.SalesOrderDetail s2 ON s1.SalesOrderID = s2.SalesOrderID
	WHERE s1.SalesPersonID IS NOT NULL
	GROUP BY s1.SalesPersonID,s1.OrderDate
SELECT * FROM vw_TotalQuantity
ORDER BY 1,2,3

--Cau 5
CREATE VIEW List_department_View AS
	SELECT h1.DepartmentID,h1.Name,AVG(h3.Rate) AS AvgOfRate
	FROM HumanResources.Department h1
	JOIN HumanResources.EmployeeDepartmentHistory h2 ON h1.DepartmentID = h2.DepartmentID
	JOIN HumanResources.EmployeePayHistory h3 ON h2.BusinessEntityID = h3.BusinessEntityID
	GROUP BY h1.DepartmentID,h1.Name
	HAVING AVG(h3.Rate) > 30
SELECT * FROM List_department_View