-- 1)Find all customers whose total revenue generated is strictly greater than the average total revenue calculated across all individual customers in the database.

WITH CustomerRevenue AS(
	SELECT c.CustomerID,
		   c.CompanyName,
		   sum(od.UnitPrice*od.Quantity*(1-od.Discount)) AS Revenue
	FROM Customers c
	JOIN Orders o ON c.CustomerID=o.CustomerID
	JOIN "Order Details" od ON o.OrderID=od.OrderID
	GROUP BY c.CustomerID,
			 c.CompanyName
)

SELECT CustomerID,
	   CompanyName,
	   Revenue
FROM CustomerRevenue
WHERE Revenue>(SELECT avg(Revenue)
			   FROM CustomerRevenue) ;

-- 2)Find the supplier(s) whose average product price is higher than the overall average product price across all suppliers. Display the supplier company name and its average product price.

WITH SupplierAveragePrice AS (
	SELECT avg(p.UnitPrice) AS AverageProductPrice,
		   s.SupplierID ,
		   s.CompanyName AS SupplierCompany
	FROM Suppliers s
	JOIN Products p ON s.SupplierID=p.SupplierID
	GROUP BY s.SupplierID , s.CompanyName
)

SELECT SupplierCompany,
	   AverageProductPrice
FROM SupplierAveragePrice
WHERE AverageProductPrice > (SELECT avg(AverageProductPrice)
							 FROM SupplierAveragePrice) ;

-- 3)Find the customers who have purchased products from the highest number of different categories. Display the customer company name and the total number of distinct categories purchased.

WITH DifferentCategories AS(
	SELECT count(DISTINCT(ca.CategoryID)) AS DistinctCategories ,
		   cu.CustomerID ,
		   cu.CompanyName AS CustomerCompany
	FROM Customers cu
	JOIN Orders o ON cu.CustomerID=o.CustomerID
	JOIN "Order Details" od ON o.OrderID=od.OrderID
	JOIN Products p ON od.ProductID=p.ProductID
	JOIN Categories ca ON p.CategoryID=ca.CategoryID
	GROUP BY cu.CustomerID ,
			 cu.CompanyName
)

SELECT CustomerCompany ,DistinctCategories
FROM DifferentCategories
WHERE DistinctCategories = (SELECT max(DistinctCategories)
							FROM DifferentCategories ) ;

-- 4) Find the customers who have placed at least 5 orders, and calculate their Average Order Value (total revenue divided by total number of orders). Display the customer company name, total order count, and their Average Order Value.

WITH AverageOrderValue AS( 
	SELECT c.CustomerID ,
		   c.CompanyName AS CustomerCompany,
		   count(DISTINCT(o.OrderID)) AS TotalOrderCount ,
		   sum(od.UnitPrice*od.Quantity*(1-od.Discount)) AS TotalRevenue
	FROM Customers c
	JOIN Orders o 
	ON c.CustomerID=o.CustomerID
	JOIN "Order Details" od
	ON o.OrderID=od.OrderID
	GROUP BY c.CustomerID, c.CompanyName
)

SELECT CustomerCompany ,
	   TotalOrderCount ,
	   TotalRevenue/TotalOrderCount AS AverageOrder
FROM AverageOrderValue
WHERE TotalOrderCount>=5 ;

-- 5) Find all product categories whose total units in stock are strictly less than the average total units in stock calculated across all categories. Display the category name and its total units in stock.

WITH Stock AS(
SELECT c.CategoryName AS ProductCategoryName, sum(p.UnitsInStock) AS TotalUnitsInStock
FROM Categories c
JOIN Products p ON c.CategoryID=p.CategoryID
GROUP BY c.CategoryName
)

SELECT ProductCategoryName ,  TotalUnitsInStock
FROM Stock 
WHERE TotalUnitsInStock < (SELECT avg(TotalUnitsInStock)
			  FROM Stock) ;
