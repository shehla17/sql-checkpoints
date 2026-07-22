-- 1) Find the top 3 most expensive products within each category using DENSE_RANK(). Display the category name, product name, unit price, and their price rank within that category.

WITH ExpensiveProducts AS(
	SELECT
		c.CategoryName,
		p.ProductName,
		p.UnitPrice,
		DENSE_RANK() OVER (
			PARTITION BY c.CategoryID
			ORDER BY p.UnitPrice DESC
		) AS PriceRank
	FROM Categories c
	JOIN Products p
		ON c.CategoryID=p.CategoryID
)

SELECT
    CategoryName,
    ProductName,
    UnitPrice,
    PriceRank
FROM ExpensiveProducts
WHERE PriceRank <= 3
ORDER BY CategoryName, PriceRank; 

-- 2) Assign a sequential order number (1, 2, 3...) to each customer's orders based on the order date using ROW_NUMBER(). Display the customer company name, order ID, order date, and the order sequence number.

SELECT
    c.CompanyName,
    o.OrderID,
	o.OrderDate,
    ROW_NUMBER() OVER (
        PARTITION BY c.CustomerID
        ORDER BY o.OrderDate
    ) AS OrderSequenceNumber
FROM Customers c
JOIN Orders o
	ON c.CustomerID=o.CustomerID
ORDER BY c.CompanyName, o.OrderDate;

-- 3) Calculate the total quantity of products for each order and compute a cumulative running total of quantity ordered by order date using SUM() OVER(). Display the order ID, order date, total quantity, and the running total quantity.

WITH ProductQuantity AS(
	SELECT sum(od.quantity) AS TotalQuantity,
	o.OrderID,
	o.OrderDate
	FROM "Order Details" od
	JOIN Orders o
		ON od.OrderID=o.OrderID
	GROUP BY o.OrderID, 
			 o.OrderDate
)

SELECT OrderID,
	   OrderDate,
	   TotalQuantity, 
SUM(TotalQuantity) OVER(
	ORDER BY OrderDate
) AS RunningTotalQuantity
FROM ProductQuantity ;

-- 4) For each order, display the employee's full name, order ID, order value, and the employee's average order value across all their handled orders using AVG() OVER().

WITH EmployeesAverageOrder AS(
	SELECT
		e.EmployeeID,
		e.FirstName || ' ' || e.LastName AS FullName,
		o.OrderID,
		sum(od.UnitPrice*od.Quantity*(1 - od.Discount)) AS OrderValue
	FROM Employees e
	JOIN Orders o
		ON e.EmployeeID=o.EmployeeID
	JOIN "Order Details" od
		ON o.OrderID=od.OrderID
	GROUP BY e.EmployeeID,
	         e.FirstName,
			 e.LastName,
			 o.OrderID
)

SELECT FullName,
	   OrderID,
	   OrderValue AS EmpOrderValue,
	 AVG(OrderValue) OVER (
        PARTITION BY EmployeeID
    ) AS AverageOrderValue
FROM EmployeesAverageOrder ;

-- 5) For each customer order, display the current order date, the previous order date placed by the same customer using LAG(), and calculate the number of days between those two orders.

WITH DaysBetween AS (
	SELECT c.CompanyName,
		   o.OrderID,
		   o.OrderDate AS CurrentOrderDate,
		   LAG(o.OrderDate) OVER(
		   PARTITION BY c.CustomerID
		   ORDER BY o.OrderDate
		   ) AS PreviousOrderDate
	FROM Orders o
	JOIN Customers c
		ON o.CustomerID=c.CustomerID 
)

SELECT CompanyName,
	   OrderID,
	   CurrentOrderDate,
	   PreviousOrderDate,
	   CurrentOrderDate - PreviousOrderDate AS DaysBetweenOrders
FROM DaysBetween ;