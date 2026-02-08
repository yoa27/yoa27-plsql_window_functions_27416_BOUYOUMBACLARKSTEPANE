# Project: SQL Analysis for TechStream Digital

**Student ID:** 27416
**Name:** BOUYOUMBA Clark Stephane
**Course:** Database Development with PL/SQL (INSY 8311)

---

## 1. Business Problem Definition

**Business Context**
This project focuses on "TechStream Digital," a digital distribution platform for video games and software. I am analyzing data for the Sales Department within the Technology and Entertainment industry.

**Data Challenge**
The company has transaction data but lacks clear insights into revenue progression and customer behavior. We currently cannot easily identify which game categories perform best or distinguish between our loyal high-spending customers and those who signed up but never bought anything.

**Expected Outcome**
By using SQL Joins and Window Functions, I expect to generate a ranked list of top-performing products and segment customers based on their spending. This will help the marketing team target inactive users and promote popular genres.

---

## 2. Success Criteria

To measure the success of this analysis, I have defined the following goals linked to SQL window functions:

1. **Rank Products:** Identify the top products per category using `RANK()`.
2. **Track Revenue:** Calculate the running total of sales over time using `SUM() OVER()`.
3. **Analyze Growth:** Compare sales with the previous transaction to see growth using `LAG()`.
4. **Segment Customers:** Divide customers into spending quartiles using `NTILE(4)`.
5. **Trend Analysis:** Use moving averages to smooth out sales data.

---

## 3. Database Schema

The database consists of three related tables: **Users**, **Products**, and **Transactions**.


![diagram](diagram.png)

4. Part A: SQL JOINS Implementation
Here I demonstrate the use of different SQL JOIN types to analyze the relationships between customers and products.

4.1 INNER JOIN
Goal: Retrieve a list of all valid transactions with customer names and product details.

''SQL

SELECT t.transaction_id, u.user_name, p.product_name, t.amount, t.sale_date
FROM Transactions t
INNER JOIN Users u ON t.user_id = u.user_id
INNER JOIN Products p ON t.product_id = p.product_id;
Result:

Interpretation: This query shows the actual sales activity. It filters out any incomplete data, showing us exactly who bought what and when.

4.2 LEFT JOIN
Goal: Identify customers who have registered but never made a purchase.

SQL

SELECT u.user_id, u.user_name
FROM Users u
LEFT JOIN Transactions t ON u.user_id = t.user_id
WHERE t.transaction_id IS NULL;
Result:

Interpretation: We found that the user "David" is inactive. The marketing team can use this list to send a "First Purchase Discount" email to encourage him to buy.

4.3 RIGHT JOIN
Goal: Detect products in our catalog that have zero sales.

SQL

SELECT p.product_name, t.transaction_id
FROM Transactions t
RIGHT JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_id IS NULL;
Result:

Interpretation: This result is empty, which is good news. It means every product in our current inventory has been sold at least once.

4.4 FULL OUTER JOIN
Goal: View all potential data points, including unmatched customers and products.

SQL

SELECT u.user_name, p.product_name, t.amount
FROM Users u
FULL OUTER JOIN Transactions t ON u.user_id = t.user_id
FULL OUTER JOIN Products p ON t.product_id = p.product_id;
Result:

Interpretation: This gives us a complete view of the database. We can see active sales alongside the inactive user (David) in one single report.

4.5 SELF JOIN
Goal: Compare customers living in the same region.

SQL

SELECT a.user_name AS Client_1, b.user_name AS Client_2, a.region
FROM Users a
JOIN Users b ON a.region = b.region
WHERE a.user_id < b.user_id;
Result:

Interpretation: This lists pairs of users from the same area. For example, Alice and Eve are both from North America. We could organize regional gaming tournaments for them.

5. Part B: Window Functions Implementation
This section uses advanced analytical functions to gain deeper insights.

5.1 Ranking Functions
Goal: Rank products by price within their category.

SQL

SELECT product_name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) as rank_by_category
FROM Products;
Result:

Interpretation: This allows us to see the most expensive items per category. "Data Master Pro" is the top-ranked software, while "Cyber Quest" is the top RPG game.

5.2 Aggregate Window Functions
Goal: Calculate a running total of sales revenue ordered by date.

SQL

SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM Transactions;
Result:

Interpretation: The running total column shows how our revenue accumulates over time. We reached a total of roughly 309.98 by early February.

5.3 Navigation Functions
Goal: Compare the current sale amount with the previous one.

SQL

SELECT sale_date, amount,
       LAG(amount, 1) OVER (ORDER BY sale_date) as previous_sale_amount
FROM Transactions;
Result:

Interpretation: Using LAG(), we can see the drop or rise between sales. For instance, after a high sale of 120, the next sale dropped to 25. This helps track volatility.

5.4 Distribution Functions
Goal: Group transactions into 4 quartiles based on amount.

SQL

SELECT user_id, amount,
       NTILE(4) OVER (ORDER BY amount DESC) as spending_quartile
FROM Transactions;
Result:

Interpretation: Group 1 represents our highest value transactions (120). Group 3 and 4 are lower value. This helps in segmenting customers for different tiers of loyalty rewards.

6. Results Analysis
Descriptive (What happened?)
The analysis shows that RPG and Software categories generate the highest individual transaction amounts. We also identified that while most users are active, there is a portion of the user base (e.g., David) that remains dormant.

Diagnostic (Why did it happen?)
The "Self Join" analysis reveals clusters of users in North America and Europe. The lack of sales for inactive users might be due to a lack of regional pricing or targeted offers in their specific location.

Prescriptive (What should be done?)
Based on the NTILE segmentation, we should focus our VIP support on customers in Quartile 1. For the inactive users found in the LEFT JOIN, I recommend sending a promotional code to convert them into paying customers.

7. References
Oracle Database SQL Language Reference, 19c.

Course Notes: INSY 8311 - Database Development with PL/SQL.

Class Tutorials on Window Functions.

8. Integrity Statement
All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.
