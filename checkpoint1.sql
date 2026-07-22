-- 1) Find all customers who ordered products supplied by companies located in the USA. Display the customer company name, supplier company, product name, and order date.

SELECT c.CompanyName as CustomerCompany, 
	s.CompanyName as SupplierCompany, 
	p.ProductName , 
	o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID=o.CustomerID
INNER JOIN "Order Details" od ON o.OrderID=od.OrderID
INNER JOIN Products p ON od.ProductID=p.ProductID
INNER JOIN Suppliers s ON s.SupplierID=p.SupplierID
WHERE s.Country='USA' ;

-- 2) Display all shipping companies with their assigned orders placed between January 1, 2013 and December 31, 2015. Show the shipping company, order ID, customer company name, and order date.

SELECT sh.CompanyName AS ShippingCompany , 
	o.OrderID , 
	c.CompanyName AS CustomerCompany , 
	o.OrderDate
FROM Shippers sh
LEFT JOIN Orders o ON sh.ShipperID=o.ShipVia
LEFT JOIN Customers c ON o.CustomerID=c.CustomerID
WHERE o.OrderDate BETWEEN '2013-01-01' AND '2015-12-31'
ORDER BY o.OrderDate ASC ;

-- 3)Display the 10 products with the highest unit price that belong to the Beverages category. Show the product name, category name, supplier company, and unit price.

SELECT p.ProductName , 
	c.CategoryName , 
	s.CompanyName AS SupplierCompany , 
	p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID=c.CategoryID
INNER JOIN Suppliers s ON p.SupplierID=s.SupplierID
WHERE c.CategoryName='Beverages'
ORDER BY p.UnitPrice DESC
LIMIT 10 ;

-- 4)Display the first 10 orders handled by employees whose Title is "Sales Representative". Show the employee full name, customer company name, shipping company, and order date.

SELECT e.FirstName || ' ' || e.LastName AS FullName , 
	c.CompanyName AS CustomerCompany , 
	sh.CompanyName AS ShipperCompany , 
	o.OrderDate
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID=o.EmployeeID
INNER JOIN Shippers sh ON o.ShipVia=sh.ShipperID
INNER JOIN Customers c ON o.CustomerID=c.CustomerID
WHERE e.Title='Sales Representative'
ORDER BY o.OrderDate ASC 
LIMIT 10 ;

-- 5)Find all orders shipped via Federal Shipping that contain products from the Seafood category. Display the customer company name, product name, shipping company, and order date.

SELECT cu.CompanyName AS CustomerCompany , 
	p.ProductName ,
	sh.CompanyName AS ShipperCompany ,  
	o.OrderDate
FROM Shippers sh
INNER JOIN Orders o ON sh.ShipperID=o.ShipVia
INNER JOIN Customers cu ON cu.CustomerID=o.CustomerID
INNER JOIN "Order Details" od ON od.OrderID=o.OrderID
INNER JOIN Products p ON p.ProductID=od.ProductID
INNER JOIN Categories ca  ON ca.CategoryID=p.CategoryID
WHERE sh.CompanyName='Federal Shipping'
AND ca.CategoryName='Seafood' ;
