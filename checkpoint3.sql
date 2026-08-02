-- 1)Find the top 5 customers who have generated the highest total revenue. Display the customer company name and the total revenue (considering unit price, quantity, and discount). Sort the results from highest to lowest revenue.

SELECT c.CustomerID, 
	c.CompanyName, 
	sum(od.UnitPrice*od.Quantity*(1-od.Discount)) AS Revenue
FROM "Order Details" od
JOIN Orders o ON od.OrderID=o.OrderID
JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY c.CustomerID,
	c.CompanyName
ORDER BY Revenue DESC
LIMIT 5 ;

-- 2)Display the monthly sales performance of the company. Show the year-month of the order date, the total number of orders placed, and the total revenue generated for each month. Sort the results chronologically from oldest to newest.

SELECT TO_CHAR(o.OrderDate, 'YYYY-MM') AS Month ,
		count(DISTINCT(o.OrderID)) AS "Total number of orders",
		sum(od.UnitPrice*od.Quantity*(1-od.Discount)) AS Revenue
FROM Orders o
JOIN "Order Details" od ON o.OrderID=od.OrderID
GROUP BY 1
ORDER BY Month ASC;

-- 3)Find the total number of unique orders placed by each customer. Display the customer company name and the total count of distinct orders, ensuring that duplicate item rows do not inflate the order totals.

SELECT c.CustomerID AS CustomerID, 
	c.CompanyName AS "The customer company name", 
	count(DISTINCT(o.OrderID)) AS "The total number of unique orders" 
FROM Customers c
JOIN Orders o ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerID , 
	c.CompanyName ;


-- 4)Analyze the shipping data to see the impact of missing region information. Display the shipping company name, the total number of all orders handled, and the total number of orders that have a valid (non-null) shipping region.

SELECT sh.CompanyName,
	count(OrderID) AS "The total number of all orders",
	count(ShipRegion) AS "Orders with Valid Region"
FROM Orders o
JOIN Shippers sh ON o.ShipVia=sh.ShipperID
GROUP BY sh.CompanyName ;

-- 5)Find all employees who have successfully sold more than 50 distinct products across all their handled orders. Display the employee's full name and the total number of unique products sold. Sort the results by the number of unique products in descending order.

SELECT e.EmployeeID , 
	e.FirstName || ' ' || e.LastName AS FullName,
	count(DISTINCT(p.ProductID)) AS "The total number of unique products sold"
FROM Employees e
JOIN Orders o 
ON e.EmployeeID=o.EmployeeID
JOIN "Order Details" od 
ON o.OrderID=od.OrderID
JOIN Products p 
ON od.ProductID=p.ProductID
GROUP BY e.EmployeeID ,
		e.FirstName,
		e.LastName
HAVING count(DISTINCT(p.ProductID)) > 50
ORDER BY 3 DESC ;
