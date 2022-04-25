CREATE PROC spGetTotalListPrice @totalPrice FLOAT OUTPUT
AS 
BEGIN
	SELECT @totalPrice = SUM(1.0*ListPrice)
	FROM Production.Product
END

CREATE PROC spGetTotalListPriceByCategory
@category NVARCHAR(10),
@totalPriceByCat FLOAT OUTPUT
AS
BEGIN
	SELECT @totalPriceByCat = SUM(p1.ListPrice)
	FROM Production.Product p1
	JOIN Production.ProductSubcategory p2 ON p2.ProductSubcategoryID = p1.ProductSubcategoryID
	JOIN Production.ProductCategory p3 ON p3.ProductCategoryID = p2.ProductCategoryID
	WHERE p3.Name = @category
END

BEGIN TRANSACTION
	DECLARE @totalPrice FLOAT
	EXEC spGetTotalListPrice @totalPrice OUT

	DECLARE @totalPriceByBike FLOAT
	EXEC spGetTotalListPriceByCategory 'Bikes', @totalPriceByBike OUT

	IF 100.0*@totalPriceByBike/@totalPrice < 60
	BEGIN
		PRINT 'Khong thuoc mang dieu kien'
		ROLLBACK
	END
	ELSE
	BEGIN
		UPDATE Production.Product
		SET ListPrice = ListPrice - 15
		WHERE ProductSubcategoryID IN (
										SELECT p2.ProductSubcategoryID
										FROM Production.ProductCategory p1
										JOIN Production.ProductSubcategory p2 ON p2.ProductCategoryID = p1.ProductCategoryID
										WHERE p1.Name = 'Bikes')

	END
	COMMIT