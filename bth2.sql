USE AdventureWorks2019
GO

--Cau 1
SELECT SalesOrderID,CarrierTrackingNumber, SUM(OrderQty * UnitPrice) as SubTotal
FROM Sales.SalesOrderDetail 
WHERE CarrierTrackingNumber LIKE '4BD%'
GROUP BY SalesOrderID,CarrierTrackingNumber

--Cau 2
SELECT s.ProductID, p.Name, AVG(s.OrderQty) as AverageOfQty
FROM Sales.SalesOrderDetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
WHERE s.UnitPrice < 25
GROUP BY s.ProductID,p.Name
HAVING AVG(s.OrderQty) > 5

--Cau 3
SELECT JobTitle, COUNT(*) as CountOfPerson
FROM HumanResources.Employee
GROUP BY JobTitle
HAVING COUNT(*) > 20

--Cau 4
SELECT p1.BusinessEntityID,p1.Name as Vendor_Name,p3.ProductID,SUM(p3.OrderQty) as SumOfQty,SUM(p3.OrderQty*p3.UnitPrice) as SubTotal
FROM Purchasing.Vendor p1
JOIN Purchasing.PurchaseOrderHeader p2 ON p1.BusinessEntityID = p2.VendorID
JOIN Purchasing.PurchaseOrderDetail p3 ON p2.PurchaseOrderID = p3.PurchaseOrderID
WHERE p1.Name LIKE '%Bicycles'
GROUP BY p1.BusinessEntityID,p1.Name, p3.ProductID
HAVING SUM(p3.OrderQty*p3.UnitPrice) > 800000
