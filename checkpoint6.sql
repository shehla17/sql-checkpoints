-- The CREATE INDEX statement is used to create indexes on database tables to speed up data retrieval. Users cannot see the indexes because they work in the background to improve query performance.
-- 	SELECT *
-- 	FROM Orders
-- 	WHERE CustomerID='ALFKI' ;
-- Without an index, the database checks every row in the Orders table until it finds all records where CustomerID = 'ALFKI'. This is called a Full Table Scan.
-- To make this search faster, an index can be created:
	CREATE INDEX idx_orders_customerid
	ON Orders(CustomerID);
-- After creating the index, the database can directly locate the matching rows instead of scanning the entire table. This significantly improves performance, especially when the table contains a large amount of data.

-- A non-correlated subquery is independent of the outer query, so it runs only once.
	SELECT CompanyName
	FROM Customers
	WHERE CustomerID IN (
		SELECT CustomerID
		FROM Orders
	);
-- Here, the inner query executes once and returns a list of customer IDs.

-- A correlated subquery depends on the outer query because it references one of its columns. Therefore, the inner query is executed repeatedly for each row processed by the outer query.
	SELECT CompanyName
	FROM Customers c
	WHERE EXISTS (
		SELECT 1
		FROM Orders o
		WHERE o.CustomerID = c.CustomerID
	);
-- The same result can often be written more efficiently using a JOIN:
	SELECT DISTINCT c.CompanyName
	FROM Customers c
	JOIN Orders o
	ON c.CustomerID = o.CustomerID;
-- Using a JOIN usually allows the database to process the relationship more efficiently than executing the subquery repeatedly.