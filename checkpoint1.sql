-- 1) Which 10 products have the highest unit price but are currently out of stock?
SELECT ProductName ,UnitPrice
FROM Products
WHERE UnitsInStock=0
ORDER BY UnitPrice DESC
LIMIT 10;

-- 2) Find the five oldest orders placed before January 1, 2015, sorted from oldest to newest.
SELECT OrderID , OrderDate
FROM Orders
WHERE OrderDate < '2015-01-01'
ORDER BY OrderDate ASC
LIMIT 5;

-- 3)Display the first 3 customers whose company name starts with the letter 'A', ordered alphabetically by company name.
SELECT CustomerID , CompanyName
FROM Customers
WHERE CompanyName like 'A%'
ORDER BY CompanyName ASC
LIMIT 3;

-- 4)Find the five cheapest products that still have more than 100 units in stock.
SELECT ProductName , UnitPrice , UnitsInStock
FROM Products
WHERE UnitsInStock>100
ORDER BY UnitPrice ASC
LIMIT 5;

-- 5)Find the 5 employees born after July 15, 1970, ordered from youngest to oldest.
SELECT FirstName , LastName , BirthDate
FROM Employees
WHERE BirthDate > '1970-07-15'
ORDER BY BirthDate desc
LIMIT 5;
