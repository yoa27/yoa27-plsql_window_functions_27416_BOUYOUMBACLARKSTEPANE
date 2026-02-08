CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    user_name VARCHAR2(100),
    region VARCHAR2(50),
    signup_date DATE
);
CREATE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    category VARCHAR2(50),
    price NUMBER(10, 2)
);
CREATE TABLE Transactions (
    transaction_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    product_id NUMBER,
    sale_date DATE,
    amount NUMBER(10, 2),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insertion des Utilisateurs
INSERT INTO Users VALUES (1, 'Alice', 'North America', TO_DATE('2025-01-10', 'YYYY-MM-DD'));
INSERT INTO Users VALUES (2, 'Bob', 'Europe', TO_DATE('2025-01-15', 'YYYY-MM-DD'));
INSERT INTO Users VALUES (3, 'Charlie', 'Asia', TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO Users VALUES (4, 'David', 'Europe', TO_DATE('2025-02-10', 'YYYY-MM-DD'));
INSERT INTO Users VALUES (5, 'Eve', 'North America', TO_DATE('2025-02-20', 'YYYY-MM-DD'));

-- Insertion des Produits (Jeux/Softwares)
INSERT INTO Products VALUES (101, 'Cyber Quest', 'RPG', 59.99);
INSERT INTO Products VALUES (102, 'Data Master Pro', 'Software', 120.00);
INSERT INTO Products VALUES (103, 'Space War', 'Action', 25.00);
INSERT INTO Products VALUES (104, 'Code Editor X', 'Software', 45.00);

-- Insertion des Transactions
INSERT INTO Transactions VALUES (501, 1, 101, TO_DATE('2026-01-05', 'YYYY-MM-DD'), 59.99);
INSERT INTO Transactions VALUES (502, 2, 102, TO_DATE('2026-01-12', 'YYYY-MM-DD'), 120.00);
INSERT INTO Transactions VALUES (503, 1, 103, TO_DATE('2026-01-20', 'YYYY-MM-DD'), 25.00);
INSERT INTO Transactions VALUES (504, 3, 101, TO_DATE('2026-02-02', 'YYYY-MM-DD'), 59.99);
INSERT INTO Transactions VALUES (505, 2, 104, TO_DATE('2026-02-05', 'YYYY-MM-DD'), 45.00);
INSERT INTO Transactions VALUES (506, 5, 102, TO_DATE('2026-02-15', 'YYYY-MM-DD'), 120.00);
 --This report displays the actual sales activity by linking transaction IDs to the real customer and game names.
SELECT t.transaction_id, u.user_name, p.product_name, t.amount, t.sale_date
FROM Transactions t
INNER JOIN Users u ON t.user_id = u.user_id
INNER JOIN Products p ON t.product_id = p.product_id;


--  LEFT JOIN: Identify customers who have never made a transaction
-- Requirement: Detect inactive records [cite: 65]
SELECT u.user_id, u.user_name
FROM Users u
LEFT JOIN Transactions t ON u.user_id = t.user_id
WHERE t.transaction_id IS NULL;

-- RIGHT JOIN: Detect products with no sales activity
-- Requirement: Find items in the catalog that are not selling 
SELECT p.product_name, t.transaction_id
FROM Transactions t
RIGHT JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_id IS NULL;
-- FULL OUTER JOIN: Compare customers and products including unmatched records
-- Requirement: Show all potential data points [cite: 67]
SELECT u.user_name, p.product_name, t.amount
FROM Users u
FULL OUTER JOIN Transactions t ON u.user_id = t.user_id
FULL OUTER JOIN Products p ON t.product_id = p.product_id;

-- SELF JOIN: Compare customers within the same region
-- Requirement: Relate records within the same table 
SELECT a.user_name AS Client_1, b.user_name AS Client_2, a.region
FROM Users a
JOIN Users b ON a.region = b.region
WHERE a.user_id < b.user_id;


--Ranking Functions: Top products by revenue per category
-- Requirement: Use RANK() to classify items [cite: 78]
SELECT product_name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) as rank_by_category
FROM Products;

-- Aggregate Window Functions: Running totals
-- Requirement: Use SUM() with ROWS/RANGE frames [cite: 79]
SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM Transactions;

--  Navigation Functions: Month-over-month growth
-- Requirement: Use LAG() to compare periods [cite: 80]
SELECT sale_date, amount,
       LAG(amount, 1) OVER (ORDER BY sale_date) as previous_sale_amount
FROM Transactions;

-- Distribution Functions: Customer segmentation
-- Requirement: Use NTILE(4) to group customers [cite: 81]
SELECT user_id, amount,
       NTILE(4) OVER (ORDER BY amount DESC) as spending_quartile
FROM Transactions;