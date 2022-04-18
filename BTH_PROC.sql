USE AdventureWorks2019
GO

-- Cau 1
CREATE PROCEDURE spGetTotalDueByMonthYear
@Month INT, @Year INT
AS
BEGIN
	SELECT CustomerID, SumOfTotalDue = SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE MONTH(OrderDate) = @Month AND YEAR(OrderDate) = @Year
	GROUP BY CustomerID
END

EXEC spGetTotalDueByMonthYear 6,2011

-- Cau 2
CREATE PROCEDURE spGetSalesYTDBySalePerson
@SalePerson INT,
@SalesYTD FLOAT OUTPUT
AS
BEGIN
	SELECT @SalesYTD = sp.SalesYTD
	FROM Sales.SalesOrderHeader soh
	JOIN Sales.SalesPerson sp ON sp.BusinessEntityID = soh.SalesPersonID
	WHERE SalesPersonID = @SalePerson
END

DECLARE @SalesYTD FLOAT
EXEC spGetSalesYTDBySalePerson 274, @SalesYTD OUT
PRINT @SalesYTD

-- Cau 3
CREATE PROCEDURE spGetListProductListPriceNotGreaterThan
@MaxPrice FLOAT
AS
BEGIN
	SELECT ProductID, ListPrice
	FROM Production.Product
	WHERE ListPrice <= @MaxPrice
END

EXEC spGetListProductListPriceNotGreaterThan 400.0

-- Cau 4
CREATE PROCEDURE spSetNewBonus AS
BEGIN
	SELECT soh.SalesPersonID, SumOfSubTotal=SUM(soh.SubTotal), NewBonus=(sp.Bonus + SUM(soh.SubTotal)*0.01)
	FROM Sales.SalesOrderHeader soh
	JOIN Sales.SalesPerson sp ON sp.BusinessEntityID = soh.SalesPersonID
	GROUP BY soh.SalesPersonID, sp.Bonus
END

EXEC spSetNewBonus

-- Cau 5
CREATE PROCEDURE spGetMaxSubTotalByYear
@Year INT
AS
BEGIN
	WITH summary_table 
	AS (
		SELECT YEAR(OrderDate) AS Year, CustomerID, SumOfSubTotal=SUM(SubTotal)
			, MAX(SUM(SubTotal)) OVER(PARTITION BY YEAR(OrderDate) ORDER BY SUM(SubTotal) DESC) AS MaxSubTotal
		FROM Sales.SalesOrderHeader
		WHERE SalesPersonID IS NOT NULL
		GROUP BY YEAR(OrderDate), CustomerID)
	SELECT DISTINCT st.Year, s.Name, st.SumOfSubTotal
	FROM summary_table st
	JOIN Sales.Customer c ON c.CustomerID = st.CustomerID
	JOIN Sales.Store s ON s.BusinessEntityID = c.StoreID
	WHERE st.SumOfSubTotal = st.MaxSubTotal AND st.Year = @Year
END

EXEC spGetMaxSubTotalByYear 2011

-- Cau 6
CREATE PROCEDURE spDeleteOrder
@SalesOrderID INT
AS
BEGIN
	IF @SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader)
	BEGIN
		DELETE FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID
		DELETE FROM Sales.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID
	END
	ELSE
		PRINT '@SalesOrderID does not exist'
END

EXEC spDeleteOrder 1