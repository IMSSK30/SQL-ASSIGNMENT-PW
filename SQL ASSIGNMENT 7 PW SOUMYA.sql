# Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
-- ans-: A Common Table Expression (CTE) is a temporary result set in SQL that is created using the WITH keyword. 
-- It exists only for the duration of the query and can be used like a table.
-- CTEs improve SQL query readability because they break complex queries into smaller, easy-to-understand parts.
-- Instead of writing long and nested subqueries, we can write the logic step by step. This makes the query easier to read, understand, and maintain.
-- In simple words, a CTE helps organize SQL queries better and makes them more readable, especially when working with complex data.

# Q2. Why are some views updatable while others are read-only? Explain with an example.
-- ans-: Some views are updatable while others are read-only because it depends on whether the DBMS can easily update the data in the original table through the view.
-- A view is updatable when it is created from a single table and does not use aggregate functions, group by, or joins. 
-- In this case, each row in the view directly corresponds to a row in the base table, so updates are possible.
-- Example (Updatable View):
CREATE VIEW Emp_View AS
SELECT emp_id, name, salary
FROM Employee;
-- This view is updatable because it is based on one table. We can update data through it:
UPDATE Emp_View
SET salary = 50000
WHERE emp_id = 1;
-- A view becomes read-only when it uses aggregate functions, group by, or joins.
-- In such cases, the DBMS cannot determine which base table row should be updated.
-- Example (Read-only View):
CREATE VIEW Dept_View AS
SELECT dept_id, AVG(salary)
FROM Employee
GROUP BY dept_id;
-- This view is read-only because it contains an aggregate function. Updating this view is not possible.
-- Conclusion:
-- Views are updatable when changes can be clearly mapped to the base table, and read-only when such mapping is not possible.

# Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
-- ans-: Advantages of Stored Procedures over writing raw SQL repeatedly:-
-- Better performance : Stored procedures are precompiled, so they execute faster than repeated SQL queries.
-- Code reusability : The same procedure can be used multiple times without rewriting the SQL code.
-- Improved security : Users can execute procedures without having direct access to database tables.
-- Easy maintenance : Changes can be made in one stored procedure instead of updating many SQL queries.
-- Reduced network traffic : Only the procedure call is sent to the database, not multiple SQL statements.
-- Consistency : Ensures the same business logic is used every time.

# Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
-- ans-: Purpose of Triggers in a Database:
-- Triggers are special database programs that "automatically execute" when a specific event occurs (INSERT, UPDATE, or DELETE).
-- They help in "maintaining data integrity" by enforcing rules without manual intervention.
-- Triggers allow "automatic actions" in response to data changes.
-- They ensure "consistency" of data across related tables.
-- Use Case where a Trigger is Essential:
-- A trigger can be used to automatically update an audit/log table whenever a record is inserted, updated, or deleted in a main table
-- (for example, recording who made the change and when).

# Q5. Explain the need for data modelling and normalization when designing a database.
-- ans-: Need for Data Modelling and Normalization in Database Design:
-- Data modelling helps in organizing data by identifying entities, attributes, and relationships before creating the database.
-- It provides a clear structure of the database, making it easier to understand and design.
-- Data modelling helps reduce design errors and improves communication between developers and users.
-- Normalization helps in reducing data redundancy by storing data in a structured manner.
-- It prevents data inconsistency by ensuring that data is stored only once.
-- Normalization improves data integrity and avoids update, insert, and delete anomalies.
-- It makes the database efficient and easy to maintain.

CREATE TABLE Products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10,2)
);

INSERT INTO Products VALUES 
(1,'KEYBOARD','ELECTRONICS', 1200),
(2,'MOUSE','ELECTRONICS', 800),
(3,'CHAIR','FURNITURE', 2500),
(4,'DESK','FURNITURE', 5500);

CREATE TABLE Sales (
SaleID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
SaleDate DATE,
FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11'); 

# Q6. Write a CTE to calculate the total revenue for each product (Revenues = Price × Quantity), and return only products where  revenue > 3000.
-- ans-:
WITH Products AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(p.Price * s.Quantity) AS Revenue
    FROM Products p
    JOIN Sales s
        ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT *
FROM Products
WHERE Revenue > 3000;

# Q7. Create a view named  vw_CategorySummary Category, TotalProducts, AveragePrice.
-- ans-:

CREATE VIEW vw_CategorySummary AS
SELECT
    Category,
    COUNT(*) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

# Q8. Create an updatable view containing ProductID, ProductName, and Price.Then update the price of ProductID = 1 using the view.
-- ans-:

-- Create the updatable view
CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;

-- Update the price for ProductID = 1 using the view
UPDATE vw_ProductDetails
SET Price = 1300
WHERE ProductID = 1;

# Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.
-- ans-:

DELIMITER $$
CREATE PROCEDURE GetProductsByCategory(IN catName VARCHAR(50))
BEGIN
    SELECT ProductID, ProductName, Category, Price
    FROM Products
    WHERE Category = catName;
END $$
DELIMITER ;

CALL GetProductsByCategory('Electronics');

# Q10. Create an AFTER DELETE trigger on the  table Products table that archives deleted product rows into a new table ProductArchive. 
-- The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.
-- ans-:

-- Step 1: Create the ProductArchive table

CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create the AFTER DELETE trigger

DELIMITER $$
CREATE TRIGGER trg_AfterDelete_Product
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price, DeletedAt)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END $$
DELIMITER ;

SELECT * FROM Products;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM Products
WHERE ProductID = 1;

SELECT * FROM Products;

SET FOREIGN_KEY_CHECKS = 1;















