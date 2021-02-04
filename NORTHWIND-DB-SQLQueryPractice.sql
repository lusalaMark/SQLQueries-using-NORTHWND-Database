-- INTRODUCTORY PROBLEMS

--1 Which shippers do we have?
SELECT * FROM shippers

--2 Certain fields from Categories
SELECT CategoryName, Description FROM Categories

--3 Sales Representatives
SELECT FirstName, LastName, HireDate
	FROM Employees
	WHERE Title = 'Sales Representative';

--4 Sales Representatives in the United States
SELECT FirstName, LastName, HireDate, Country
	FROM Employees
	WHERE Title = 'Sales Representative' AND Country = 'USA'; 
--5 Order placeds by specific EmployeeID
SELECT OrderID, OrderDate
	FROM Orders
	WHERE EmployeeID = 5;
select * from Orders
--6 Suppliers and ContacTitles
SELECT SupplierID, ContactName, ContactTitle
	FROM Suppliers
	WHERE ContactTitle != 'MarketingManager'; -- The unequal operator can also be <>

--7 Products with "queso" in ProductName
SELECT PRoductID, ProductName
	FROM Products
	WHERE ProductName LIKE '%queso%';

--8 Orders shipping to France or Belgium
SELECT OrderID, CustomerID, ShipCountry
	FROM Orders
	WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium';
	-- Alternatively: WHERE ShipCountry IN ('France', 'Belgium')

--9 Orders shipping to any country in Latin America
SELECT OrderID, CustomerID, ShipCountry
	FROM Orders
	WHERE ShipCountry IN ('Brazil', 'Mexico', 'Venezuela', 'Argentina');

--10 Employees, in order of age
SELECT FirstName, LastName, Title, BirthDate
	FROM Employees
	ORDER BY BirthDate;

--11 Showing only the Date with a DateTime field
SELECT FirstName, LastName, Title, CONVERT(date, BirthDate) AS DateOnlyBirthDate
	FROM Employees
	ORDER BY BirthDate;

--12 Employees full name
SELECT FirstName, LastName, CONCAT(FirstName, ' ',LastName) AS FullName
	FROM Employees;

--13 OrderDetails amount per line item
SELECT OrderID, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) AS TotalPrice
	FROM OrderDetails;

--14 How many customers?
SELECT COUNT(DISTINCT CustomerID) AS TotalCustomers
	FROM Customers;

--15 When was the first order?
SELECT MIN(OrderDate) AS FirstOrder
	FROM Orders;
	-- Alternatively:
	SELECT TOP 1 OrderDate --Similar to LIMIT operator in MySQL
		FROM Orders

--16 Countries where there are customers
SELECT DISTINCT(Country)
	FROM Customers;
	-- Alternatively:
	SELECT Country
		FROM Customers
		GROUP BY Country;

--17 Contact titles for customers
SELECT ContactTitle, COUNT(ContactTitle) AS TotalContacTitle
	FROM Customers
	GROUP BY ContactTitle
	ORDER BY TotalContacTitle DESC;

--18 Products with associated supplier names
SELECT ProductID, ProductName, Suppliers.CompanyName AS Supplier
	FROM Products
	JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
	ORDER BY ProductID;

--19 Orders and the Shipper that was used

--Previous exploratory queries
SELECT DISTINCT(ShipVia) FROM Orders;
SELECT ShipperID FROM Shippers;
SELECT DISTINCT(COLUMN_NAME), TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'Orders' OR TABLE_NAME = 'Shippers'
 ORDER BY COLUMN_NAME;

--Actual Answer
SELECT OrderID, CONVERT(date, OrderDate) AS OrderDate, Shippers.CompanyName AS Shipper
	FROM Orders
	JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
	WHERE OrderID < 10270
	ORDER BY OrderID;

-- END OF INTRODUCTORY PROBLEMS

-- INTERMEDIATE PROBLEMS

--20 Categories, and the total products in each category
SELECT 
	Categories.CategoryName,
	COUNT(Products.ProductID) AS TotalProducts
	FROM Products
	JOIN Categories 
		ON Products.CategoryID = Categories.CategoryID
	GROUP BY Categories.CategoryName
	ORDER BY TotalProducts DESC;

--21 Total customers per country/city
SELECT Country, City, COUNT(CustomerID) AS TotalCustomers
	FROM Customers
	GROUP BY Country, City
	ORDER BY TotalCustomers DESC;

--22 Products that need reordering
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
	FROM Products
	WHERE UnitsInStock <= ReorderLevel
	ORDER BY ProductID;

--23 Products that need reordering, continued
SELECT ProductID,
	ProductName,
	UnitsInStock,
	UnitsOnOrder,
	ReorderLevel,
	Discontinued
	FROM Products
	WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
		AND Discontinued = 0;

--24 Customer list by region
SELECT
	CustomerID,
	CompanyName,
	ContactName,
	Country,
	Region,
	CASE WHEN Region IS NULL THEN 1
		ELSE 0
		END AS RegionOrder
	FROM Customers
	ORDER BY RegionOrder, CustomerID;


--25 High freight charges
SELECT TOP 3
	ShipCountry,
	AVG(Freight) AS AvgFreight
	FROM Orders
	GROUP BY ShipCountry
	ORDER BY AvgFreight DESC;
	--LIMIT 3; *Would have been the solution in MySQL, instead of `TOP 3`.

--26 High freight charges—2015
SELECT TOP 3
	ShipCountry,
	AVG(Freight) AS AvgFreight
	FROM Orders
	WHERE CONVERT(date,OrderDate) LIKE '2015-%'
	/*	Alternative solution:
	WHERE OrderDate >= '1/1/2015'
		AND OrderDate <= '1/1/2016'
	*/
	GROUP BY ShipCountry
	ORDER BY AvgFreight DESC;

--27 High freight charges with between
SELECT
	OrderID,
	OrderDate,
	ShipCountry,
	Freight
	FROM Orders
	WHERE CONVERT(date,OrderDate) LIKE '2015-%'
	ORDER BY Freight DESC;
/*The misleading order could be OrderID 10806, 
which OrderDate is 2015-12-31 11:00:00.000*/

--28 High freight charges—last year
SELECT TOP 3
	ShipCountry,
	AVG(Freight) AS AvgFreight
	FROM Orders
	WHERE OrderDate >= 
		(SELECT
		DATEADD(yy, -1, MAX(CONVERT(date, OrderDate)))
		FROM Orders)
	GROUP BY ShipCountry
	ORDER BY AvgFreight DESC;
/*Result is slightly different from that on the book (USA 119.3032)
but I see no reason for that and running the proposed solution gave 
back the same table, so I'm considering this one fine as well.*/

--29 Employee/Order Detail report
SELECT
	e.EmployeeID,
	e.LastName,
	o.OrderID,
	p.ProductName,
	d.Quantity
	FROM Orders AS o
	LEFT JOIN Employees AS e
		ON o.EmployeeID = e.EmployeeID
	LEFT JOIN OrderDetails as d
		ON o.OrderID = d.OrderID
	LEFT JOIN Products as p
		ON d.ProductID = p.ProductID
	ORDER BY o.OrderID, p.ProductID;

--30 Customers with no orders
SELECT
	c.CustomerID,
	o.CustomerID
	FROM Customers c
	LEFT JOIN Orders o
		ON c.CustomerID = o.CustomerID
	WHERE O.CustomerID IS NULL;

--31 Customers with no orders for EmployeeID 4
/*SELECT
	Customers.CustomerID
	FROM Customers
	LEFT JOIN (SELECT 
						CustomerID
						FROM Orders
						WHERE EmployeeID != 4
						GROUP BY CustomerID) AS SubQuery 
		ON Customers.CustomerID = SubQuery.CustomerId
*/
	
-- END OF INTERMEDIATE PROBLEMS

-- ADVANCED PROBLEMS

--32 High-value customers


--33 High-value customers—total orders


--34 High-value customers—with discount


--35 Month-end orders


--36 Orders with many line items


--37 Orders—random assortment


--38 Orders—accidental double-entry 


--39 Orders—accidental double-entry details


--40 Orders—accidental double-entry details, derived table


--41 Late orders


--42 Late orders—which employees?


--43 Late orders vs. total orders


--44 Late orders vs. total orders—missing employee


--45 Late orders vs. total orders—fix null


--46 Late orders vs. total orders—percentage


--47 Late orders vs. total orders—fix decimal


--48 Customer grouping


--49 Customer grouping—fix null


--50 Customer grouping with percentage


--51 Customer grouping—flexible


--52 Countries with suppliers or customers


--53 Countries with suppliers or customers v.2


--54 Countries with suppliers or customers v.3


--55 First order in each country


--56 Customers with multiple orders in 5 day period


--57 Customers with multiple orders in 5 day period, v.2


-- END OF ADVANCED PROBLEMS
