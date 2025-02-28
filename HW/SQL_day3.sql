--1.      List all cities that have both Employees and Customers.
SELECT City
FROM Customers
UNION
SELECT City
FROM Employees
--2.      List all cities that have Customers but no Employee.
--a.      Use sub-query
SELECT c.City
FROM Customers as c LEFT JOIN Employees as e ON C.City = e.City
WHERE e.City is null
--b.      Do not use sub-query
SELECT c.City
FROM Customers as c
WHERE c.City NOT IN (SELECT e.City
FROM Employees as e)
--3.      List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(D.Quantity) as TotalQuantity
FROM Products as p LEFT JOIN [Order Details] as d ON d.ProductID = p.ProductID
group by p.ProductName
--4.      List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(d.Quantity) AS TotalProducts
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN [Order Details] AS d ON o.OrderID = d.OrderID
GROUP BY c.City
--5.      List all Customer Cities that have at least two customers.
SELECT CITY
FROM Customers
group by CITY
HAVING COUNT(CustomerID) > 2
--6.      List all Customer Cities that have ordered at least two different kinds of products.
SELECT C.City
FROM Customers as c JOIN Orders as o ON o.CustomerID = c.CustomerID
JOIN [Order Details] as d ON d.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT ProductID) > 2
--7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT O.ShipCity, c.City
FROM Customers as c JOIN Orders as o ON o.CustomerID = c.CustomerID
WHERE c.City <> o.ShipCity
--8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

WITH PopularPro AS (
SELECT p.ProductName, c.City, AVG(p.UnitPrice) as avgp, SUM(d.Quantity) as total,
RANK() OVER (PARTITION BY p.ProductName ORDER BY SUM(d.Quantity) DESC) AS city_rank
FROM Products AS p JOIN [Order Details] AS d ON p.ProductID = d.ProductID
JOIN Orders as o ON d.OrderID = o.OrderID
JOIN Customers as c ON c.CustomerID = o.CustomerID
GROUP BY p.ProductName, c.City
),
Ranking AS (
    SELECT TOP 5 ProductName, SUM(total) AS total_sales
    FROM PopularPro
    GROUP BY ProductName
    ORDER BY total_sales DESC
)
SELECT pp.ProductName,  pp.avgp, pp.City
FROM PopularPro pp JOIN Ranking r ON pp.ProductName = r.ProductName
WHERE pp.city_rank = 1
ORDER BY r.total_sales DESC;
--9.      List all cities that have never ordered something but we have employees there.
--a.      Use sub-query
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
SELECT c.City
FROM Customers as c LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID
WHERE o.OrderID is not null)
--b.      Do not use sub-query
SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN Customers c ON e.City = c.City
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

--10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
WITH OrderCity AS (
    SELECT e.City AS EmployeeCity,
        COUNT(o.OrderID) AS OrderCount,
        RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) AS OrderRank
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
),
ProductQuantity AS (
    SELECT 
        c.City AS CustomerCity,
        SUM(od.Quantity) AS TotalQuantity,
        RANK() OVER (ORDER BY SUM(od.Quantity) DESC) AS QuantityRank
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.City
)
SELECT oc.EmployeeCity AS City
FROM OrderCity oc
JOIN ProductQuantity pq ON oc.EmployeeCity = pq.CustomerCity
WHERE oc.OrderRank = 1 AND pq.QuantityRank = 1;

--11. How do you remove the duplicates record of a table?
-- You create a new table containing only the unique records, drop your original table, and then rename the new one.
