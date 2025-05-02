--Basic SQL queries to get to know the dataset

-- Get all customers from New York
SELECT * FROM customers WHERE city = 'New York';

-- Get the total number of products in stock
SELECT SUM(stock_quantity) AS total_stock FROM products;

-- Get all orders made by customer with ID 10
SELECT * FROM orders WHERE customer_id = 10;



------------------------------------------------------------------------------------------------------------------
---Knowledge of aggregate functions

-- Get total revenue from all orders
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- Get average order amount
SELECT AVG(total_amount) AS avg_order_value FROM orders;


-- Count the number of customers by city
SELECT city, COUNT(*) AS num_customers FROM customers GROUP BY city;



------------------------------------------------------------------------------------------------------------------
---Knowledge of date functions

-- Get orders placed in the last 30 days
SELECT * FROM orders WHERE order_date >= DATE('now', '-30 days');

-- Count new customers per month
SELECT strftime('%Y-%m', signup_date) AS signup_month, COUNT(*) AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;

------------------------------------------------------------------------------------------------------------------
--Knowledge of basic JOINs 

-- Get order details including customer name and total amount
SELECT o.order_id, c.name AS customer_name, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Get detailed order items including product name and price
SELECT oi.order_id, p.name AS product_name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;


------------------------------------------------------------------------------------------------------------------
--Knowledge of window functionscustomers-- Rank customers by total spending
SELECT customer_id, SUM(total_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank
FROM orders
GROUP BY customer_id;

-- Calculate running total of orders
SELECT order_id, order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;


------------------------------------------------------------------------------------------------------------------



--Knowledge of subqueries/nested queriescustomers
-- Get customers who have spent more than $1000
SELECT customer_id, name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > 1000
);

-- Find the most expensive product
SELECT * FROM products
WHERE price = (SELECT MAX(price) FROM products);
