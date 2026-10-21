create database shopsphere;

-- ShopSphere: 15 business questions
USE shopsphere;
show tables;

SELECT (SELECT COUNT(*) FROM sales_clean) AS sales_rows,
       (SELECT COUNT(*) FROM customers)   AS customers,
       (SELECT COUNT(*) FROM products)    AS products,
       (SELECT COUNT(*) FROM date_dim)    AS dates;

-- Q1. How much did we sell and earn each year?
SELECT d.year, SUM(f.Net_Sales) AS total_sales, SUM(f.Profit) AS total_profit
FROM sales_clean f
JOIN date_dim d ON f.Order_Date = d.date_key
WHERE f.Order_Status = 'Delivered'
GROUP BY d.year
ORDER BY d.year;

-- Q2. Which category makes the most profit?
SELECT p.category, SUM(f.Net_Sales) AS total_sales, SUM(f.Profit) AS total_profit,
       ROUND(100 * SUM(f.Profit) / SUM(f.Net_Sales), 1) AS profit_per_100_sales
FROM sales_clean f
JOIN products p ON f.Product_Id = p.product_id
WHERE f.Order_Status = 'Delivered'
GROUP BY p.category
ORDER BY total_profit DESC;

-- Q3. Which region sells the most?
SELECT c.region, SUM(f.Net_Sales) AS total_sales, SUM(f.Profit) AS total_profit
FROM sales_clean f
JOIN customers c ON f.Customer_Id = c.customer_id
WHERE f.Order_Status = 'Delivered'
GROUP BY c.region
ORDER BY total_sales DESC;

-- Q4. Which months sell the most in 2025?
SELECT d.month_name, SUM(f.Net_Sales) AS total_sales
FROM sales_clean f
JOIN date_dim d ON f.Order_Date = d.date_key
WHERE f.Order_Status = 'Delivered' AND d.year = 2025
GROUP BY d.month_no, d.month_name
ORDER BY d.month_no;

-- Q5. Who are our top 10 customers?
SELECT c.customer_name, c.city, SUM(f.Net_Sales) AS total_sales, SUM(f.Profit) AS total_profit
FROM sales_clean f
JOIN customers c ON f.Customer_Id = c.customer_id
WHERE f.Order_Status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_sales DESC
LIMIT 10;

-- Q6. Do weekends sell more than weekdays?
SELECT d.is_weekend, COUNT(*) AS orders, SUM(f.Net_Sales) AS total_sales,
       ROUND(AVG(f.Net_Sales), 0) AS average_order
FROM sales_clean f
JOIN date_dim d ON f.Order_Date = d.date_key
WHERE f.Order_Status = 'Delivered'
GROUP BY d.is_weekend;

-- Q7. Which category gets the most returns?
SELECT p.category, COUNT(*) AS returned_orders
FROM sales_clean f
JOIN products p ON f.Product_Id = p.product_id
WHERE f.Order_Status = 'Returned'
GROUP BY p.category
ORDER BY returned_orders DESC;

-- Q8. Do campaigns make money?
SELECT Campaign_Name, COUNT(*) AS orders, SUM(Net_Sales) AS total_sales, SUM(Profit) AS total_profit,
       ROUND(100 * SUM(Profit) / SUM(Net_Sales), 1) AS profit_per_100_sales
FROM sales_clean
WHERE Order_Status = 'Delivered'
GROUP BY Campaign_Name
ORDER BY profit_per_100_sales DESC;

-- Q9. Which loyalty tier spends the most?
SELECT c.loyalty_tier, COUNT(*) AS orders, SUM(f.Net_Sales) AS total_sales,
       ROUND(AVG(f.Net_Sales), 0) AS average_order
FROM sales_clean f
JOIN customers c ON f.Customer_Id = c.customer_id
WHERE f.Order_Status = 'Delivered'
GROUP BY c.loyalty_tier
ORDER BY total_sales DESC;

-- Q10. Which 5 products make the most profit?
SELECT p.product_name, p.category, SUM(f.Profit) AS total_profit
FROM sales_clean f
JOIN products p ON f.Product_Id = p.product_id
WHERE f.Order_Status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC
LIMIT 5;

-- Q11. How many customers never bought anything?
SELECT COUNT(*) AS customers_never_bought
FROM customers
WHERE customer_id NOT IN (SELECT Customer_Id FROM sales_clean);

-- Q12. How many days does delivery take in each region?
SELECT c.region, ROUND(AVG(f.Delivery_Days), 1) AS average_delivery_days
FROM sales_clean f
JOIN customers c ON f.Customer_Id = c.customer_id
WHERE f.Order_Status = 'Delivered' AND f.Sales_Channel <> 'In-Store'
GROUP BY c.region
ORDER BY average_delivery_days DESC;

-- Q13. Which category gets the best review rating?
SELECT p.category, ROUND(AVG(f.Review_Rating), 2) AS average_rating
FROM sales_clean f
JOIN products p ON f.Product_Id = p.product_id
GROUP BY p.category
ORDER BY average_rating DESC;

-- Q14. Which 5 sales reps earn the most profit?
SELECT Sales_Rep, COUNT(*) AS orders, SUM(Net_Sales) AS total_sales, SUM(Profit) AS total_profit
FROM sales_clean
WHERE Order_Status = 'Delivered'
GROUP BY Sales_Rep
ORDER BY total_profit DESC
LIMIT 5;

-- Q15. How much money do we lose to returns, and why?
SELECT Return_Reason, COUNT(*) AS returned_orders, SUM(Net_Sales) AS sales_lost
FROM sales_clean
WHERE Order_Status = 'Returned'
GROUP BY Return_Reason
ORDER BY sales_lost DESC;




