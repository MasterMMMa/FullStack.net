--1.      How many products can you find in the Production.Product table?
SELECT COUNT(ProductID)
FROM Production.Product

--2.      Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT null

--3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--ProductSubcategoryID CountedProducts
---------------------- ---------------
SELECT ProductSubcategoryID, COUNT(ProductID) as CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID


--4.      How many products that do not have a product subcategory.
SELECT COUNT(ProductID)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) as totalQuantity
FROM Production.ProductInventory

--6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--              ProductID    TheSum
--              -----------        ----------
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7.    Write a query to list the sum of products with the shelf information in the c table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--    Shelf      ProductID    TheSum
--    ----------   -----------        -----------
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

--9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--    ProductID   Shelf      TheAvg
--    ----------- ---------- -----------
SELECT ProductID,Shelf,AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

--10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--    ProductID   Shelf      TheAvg
--    ----------- ---------- -----------
SELECT ProductID,Shelf,AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY Shelf, ProductID

--11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--    Color                        Class              TheCount          AvgPrice
--    -------------- - -----    -----------            ---------------------
SELECT Color, Class, COUNT(*)AS Thecount, AVG(ListPrice) as AvgPrice
FROM Production.Product
WHERE Color is not null AND Class is not null
GROUP BY Color, Class

--Joins:

--12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
--    Country                        Province
--    ---------                          ----------------------
SELECT c.Name as Country, s.Name as Province
FROM Person. CountryRegion as c
JOIN Person. StateProvince as s ON c.CountryRegionCode = s.CountryRegionCode

--13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--    Country                        Province
--    ---------                          ----------------------
SELECT c.Name as Country, s.Name as Province
FROM Person. CountryRegion as c
JOIN Person. StateProvince as s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name = 'Germany' OR c.Name = 'Canada'

-- Using Northwnd Database: (Use aliases for all the Joins)
--14.  List all Products that has been sold at least once in last 27 years.
USE Northwind
GO
SELECT DISTINCT p.ProductName
FROM [Order Details] as d JOIN Products AS p ON d.ProductID = p.ProductID
JOIN Orders AS o ON d.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())

--15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode, SUM(d.Quantity) AS TotalQuantity
FROM Orders AS o JOIN [Order Details] as d ON o.OrderID = d.OrderID
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

--16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT TOP 5 o.ShipPostalCode, SUM(d.Quantity) AS TotalQuantity
FROM Orders AS o JOIN [Order Details] as d ON o.OrderID = d.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

--17.   List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City

--18.  List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) as CustomerNum
FROM Customers
GROUP BY City
HAVING  COUNT(CustomerID) > 2

--19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.CompanyName
FROM Customers as c JOIN Orders as o ON c.CustomerID = o.CustomerID
WHERE ShippedDate > '1998-01-01'

--20.  List the names of all customers with most recent order dates
SELECT c.CompanyName, MAX(O.OrderDate) AS MostRecentDate
FROM Customers as c JOIN Orders as o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName

--21.  Display the names of all customers  along with the  count of products they bought
SELECT c.CompanyName, SUM(d.Quantity) as CountOfProducts
FROM Customers as c 
JOIN Orders as o ON c.CustomerID = o.CustomerID
JOIN [Order Details] as d ON o.OrderID = d.OrderID
GROUP BY c.CompanyName

--22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(d.Quantity) as CountOfProducts
FROM Customers as c 
JOIN Orders as o ON c.CustomerID = o.CustomerID
JOIN [Order Details] as d ON o.OrderID = d.OrderID
GROUP BY c.CustomerID
HAVING SUM(d.Quantity)>100

--23.  List all of the possible ways that suppliers can ship their products. Display the results as below
--    Supplier Company Name                Shipping Company Name
--    ---------------------------------            ----------------------------------
SELECT su.CompanyName , sh.CompanyName
FROM dbo.Suppliers AS su
CROSS JOIN dbo.Shippers AS sh

--25.  Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' + e1.LastName AS Employee1,  e2.FirstName + ' ' + e2.LastName AS Employee2, e1.Title AS JobTitle
FROM Employees AS e1
JOIN Employees AS e2 ON e1.Title = e2.Title AND e1.EmployeeID <> e2.EmployeeID

--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT e2.LastName + ' ' + e2.FirstName as Manager, COUNT(*) as EmployeeCount
FROM Employees as e
JOIN Employees as e2 ON e.ReportsTo = e2.EmployeeID
GROUP BY e2.EmployeeID, e2.LastName, e2.FirstName
HAVING COUNT(*) > 2

--27.  Display the customers and suppliers by city. The results should have the following columns
--City
--Name
--Contact Name,
--Type (Customer or Supplier)
SELECT c.City, 
       c.CompanyName AS Name,
       c.ContactName AS [Contact Name],
       'Customer' AS Type
FROM Customers AS c
UNION
SELECT s.City,
       s.CompanyName AS Name,
       s.ContactName AS [Contact Name],
       'Supplier' AS Type
FROM Suppliers AS s
