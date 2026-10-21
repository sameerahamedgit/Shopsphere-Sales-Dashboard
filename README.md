# ShopSphere Retail Sales Analytics using MySQL and Power BI

## Project Information

**Project Title:**
ShopSphere Retail Sales Analytics using MySQL and Power BI

**Industry Name:**
Retail / E-commerce (omnichannel retail)

**Problem Statement:**
ShopSphere is a retailer that sells through a website, a mobile app, physical stores and marketplaces. The business has sales data spread across four tables and no single view of where revenue and profit come from, where profit is lost, and which customers, products and campaigns perform well. Without this view, decisions on discounts, categories and returns are made without evidence.

**Project Objectives:**
- Clean the raw sales data and load it into a MySQL database.
- Answer 15 business questions with SQL, using joins across the sales, customer, product and date tables.
- Build a Power BI data model and a two-page dashboard with DAX measures.
- Identify where profit is earned, where it is lost, and what the business can act on.

**Proposed Solution / Business Questions:**
The raw data was cleaned, loaded into MySQL as a star schema (one fact table and three dimension tables), analysed with SQL, and presented in an interactive Power BI dashboard. The project answers:
1. How do sales and profit change by year and by month?
2. Which categories, regions and sales channels earn the most?
3. Do discount campaigns make or lose money?
4. How much is lost to returns, and for what reasons?
5. Who are the top customers, and which customer groups spend the most?
6. How many customers have never bought anything?

**Dataset Name:**
ShopSphere retail dataset (sales, customers, products and calendar tables)

**Dataset Source:**
[Enter the actual dataset source]

**Database Name:**
`shopsphere`

**Table Names:**
`sales_clean`, `customers`, `products`, `date_dim`

---

## Tools & Technologies

- MySQL 8 and MySQL Workbench
- SQL
- Power BI Desktop
- Power Query
- DAX
- Microsoft Excel (data cleaning)
- CSV files (raw data)
- GitHub

---

## Project Overview

ShopSphere is a retail business with four sales channels: website, mobile app, physical stores and marketplaces. This project takes its transaction data from raw files to a working dashboard. The data was checked and cleaned, stored in MySQL, queried with SQL joins to answer business questions, and visualised in Power BI.

The purpose of the analysis is to give the business one clear view of sales, profit, returns, campaigns and customers, so that findings can be discussed and acted on. The findings are descriptive: they describe what the data shows and do not claim any outcome that has not been measured.

**Business rule used throughout:** "sales" means orders with status **Delivered**. Cancelled, Returned and In Transit orders are not counted as revenue.

---

## Project Objectives

- Clean the raw sales data and document every cleaning step.
- Build a MySQL database with one fact table and three dimension tables.
- Write SQL queries that use joins, grouping and aggregate functions to answer 15 business questions.
- Build a Power BI star-schema data model with DAX measures.
- Design a two-page dashboard with KPI cards, charts, a table and filters.
- Report key insights using only values calculated from the data.

---

## Dataset Information

| Table | Rows | Columns | Description |
|---|---|---|---|
| `sales_fact` (raw) / `sales_clean` (cleaned) | 2,618 raw, 2,600 cleaned | 44 | One row per order line: dates, amounts, discount, profit, status, channel, campaign, delivery and review fields |
| `customers` | 620 | 15 | Customer name, age group, city, state, region, segment, loyalty tier, signup date |
| `products` | 35 | 9 | Product name, category, sub-category, brand, price, cost, supplier, stock |
| `date_dim` | 1,004 | 10 | Calendar from 2024-01-01 to 2026-09-30: year, quarter, month, week, weekend flag, fiscal year |

**Important columns in the sales table:** Order ID, Order Date, Customer ID, Product ID, Sales Channel, Payment Method, Campaign Name, Quantity, Unit Price, Discount %, Gross Amount, Net Sales, Cost of Goods Sold, Profit, Order Status, Delivery Days, Return Reason, Review Rating, Sales Rep.

### Data cleaning log

| Problem found | Rows | Fix |
|---|---|---|
| Duplicate order lines | 18 | Removed, keeping one copy of each |
| Extra spaces in customer name and city | 21 and 6 | `TRIM` |
| Payment method spelled in different ways (`upi`, `credit card`, `wallet`, `cash on delivery`) | 11 | Standardised to one spelling each |
| Campaign written as "None" instead of a name | 781 | Replaced with `No Campaign` |
| Blank return reason for orders that were not returned | 2,460 | Replaced with `Not Returned` |
| Missing discount % | 19 | Calculated as discount amount / gross amount x 100 |
| Missing delivery days | 17 | Calculated as delivery date minus order date |
| Category labels in the sales table written with "and" instead of "&" | 10 | Made consistent with the products table |
| City written in capital letters in the sales table | 13 | Made consistent with the customers table |

The row counts above are counted on the raw file, so some of them include the 18 duplicate rows.

**Blanks kept on purpose:** `delivery_date` and `review_rating` are blank (NULL) for Returned, Cancelled and In Transit orders (370 rows), and 3 orders have no `delivery_days`. These values do not exist in the source data, so they were left blank instead of being guessed.

---

## Project Workflow

**Industry Selection → Problem Identification → Dataset Collection → MySQL Database Setup → Data Cleaning & Transformation Using SQL → SQL Data Analysis → Power BI Data Modeling → Dashboard Development → Insights & Recommendations**

In this project, data cleaning was carried out in Excel and in the SQL setup script (`SQL/shopsphere_full_setup.sql`), which creates the database and loads the cleaned tables.

---

## SQL Analysis

All queries are in `SQL/shopsphere_15_simple_questions.sql`. The database and tables are created by `SQL/shopsphere_full_setup.sql`.

**SQL concepts used:**
- `CREATE DATABASE`, `CREATE TABLE`, primary keys, `INSERT` (database setup)
- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, column aliases (`AS`)
- Aggregate functions: `SUM`, `COUNT`, `AVG`, `ROUND`
- `GROUP BY` for grouped summaries
- `JOIN` between the sales table and the customers, products and date tables
- A subquery with `NOT IN`

| # | Business question | Tables joined |
|---|---|---|
| 1 | Sales and profit by year | sales, date_dim |
| 2 | Profit and margin by category | sales, products |
| 3 | Sales by region | sales, customers |
| 4 | Monthly sales in 2025 | sales, date_dim |
| 5 | Top 10 customers by sales | sales, customers |
| 6 | Weekend vs weekday sales | sales, date_dim |
| 7 | Returned orders by category | sales, products |
| 8 | Profit margin by campaign | sales |
| 9 | Sales by loyalty tier | sales, customers |
| 10 | Top 5 products by profit | sales, products |
| 11 | Customers who never bought | customers, sales (subquery) |
| 12 | Average delivery days by region | sales, customers |
| 13 | Average review rating by category | sales, products |
| 14 | Top 5 sales reps by profit | sales |
| 15 | Sales lost to returns by reason | sales |

---

## Power BI Dashboard

- **Data import:** the four tables were imported from the MySQL database `shopsphere`.
- **Power Query:** removed 12 columns from the sales table that repeat customer and product details already held in the dimension tables; checked and set data types; renamed columns to readable names (for example `Net_Sales` became `Net Sales`); renamed the tables to Sales, Customers, Products and Dates.
- **Data model:** star schema with `Sales` in the centre.
  - `Sales[Customer ID]` to `Customers[Customer ID]` (many to one)
  - `Sales[Product ID]` to `Products[Product ID]` (many to one)
  - `Sales[Order Date]` to `Dates[Date Key]` (many to one), with `Dates` marked as the date table
- **Calculated column:** `Month Short = LEFT(Dates[Month Name], 3)`, sorted by month number
- **DAX measures:**

```
Total Sales = CALCULATE(SUM(Sales[Net Sales]), Sales[Order Status] = "Delivered")
Total Profit = CALCULATE(SUM(Sales[Profit]), Sales[Order Status] = "Delivered")
Total Orders = CALCULATE(COUNTROWS(Sales), Sales[Order Status] = "Delivered")
Profit Margin % = DIVIDE([Total Profit], [Total Sales])
Average Order Value = DIVIDE([Total Sales], [Total Orders])
Returned Orders = CALCULATE(COUNTROWS(Sales), Sales[Order Status] = "Returned")
Return Rate % = DIVIDE([Returned Orders], CALCULATE(COUNTROWS(Sales), Sales[Order Status] IN {"Delivered", "Returned"}))
Sales Lost to Returns = CALCULATE(SUM(Sales[Net Sales]), Sales[Order Status] = "Returned")
```

**Page 1: Executive Summary**
- KPI cards: Total Sales, Total Profit, Total Orders, Profit Margin %
- Area chart: Monthly Sales Trend
- Bar chart: Profit by Category
- Column chart: Sales by Channel
- Pie chart: Sales Share by Loyalty Tier
- Key Insights card
- Slicers: Year and Region

**Page 2: Regions and Returns**
- KPI cards: Returned Orders, Return Rate %, Sales Lost to Returns
- Bar chart: Sales by Region
- Bar chart: Sales Lost to Returns by Reason
- Bar chart: Profit Margin by Campaign
- Donut chart: Order Status Mix
- Table: Top 10 Customers by Sales (filtered with Top N on Customer ID, because customer names are not unique)
- Slicers: Year and Region

**Layout and design:** custom colour theme (`ShopSphere_Theme.json`), a header background image with logo and title, and a page navigator to switch between the two pages.

---

## Data Analysis & Visualization

- **Time-based analysis:** sales, profit and margin by year; monthly sales trend
- **Category-wise analysis:** sales, profit, margin and returns by product category
- **Performance analysis:** regions, sales channels, campaigns, sales reps and top customers
- **Comparison analysis:** campaign vs no-campaign margin; weekday vs weekend orders; loyalty tiers
- **KPI analysis:** total sales, profit, orders, margin, return rate and sales lost to returns
- **Distribution analysis:** order status mix and loyalty tier share of sales

---

## Key Insights

All values below are calculated from the delivered orders in the dataset unless stated otherwise.

1. **Yearly performance:** sales were 7.53M in 2024 and 5.96M in 2025, while profit stayed almost the same (827K in 2024 and 833K in 2025) because the profit margin rose from 11.0% to 14.0%. 2026 contains data only up to September (4.73M sales, 588K profit).
2. **Electronics:** about 68% of all sales come from Electronics (12.35M), but its profit margin is only 4.2%. Fashion (42.7%) and Beauty & Personal Care (45.1%) earn much higher margins on smaller sales.
3. **Campaigns:** orders with no campaign earn a 24.4% profit margin. Campaigns earn between 2.5% (Monsoon Carnival) and 13.4% (Festive Dhamaka), with average discounts of about 15% to 17%.
4. **Returns:** 157 orders were returned. They represent 1.68M in sales and 276K in profit. Size Issue is the largest reason (630K in sales), followed by Wrong Item and Damaged. Electronics has the most returned orders (34).
5. **Regions:** South is the largest region (5.57M sales, 736K profit). East is second in sales (3.48M) but lowest in profit (330K).
6. **Channels:** the Mobile App is the largest channel (6.89M), followed by In-Store (5.16M) and the Website (4.79M).
7. **Customers:** the top customer, Shreya Menon, bought 349K. Three of the top 10 customers have negative total profit. 103 of 620 customers (17%) have never placed an order.
8. **Delivery:** average delivery time (excluding In-Store orders) is between 4.8 and 5.1 days in every region.

---

## Power BI Dashboard Screenshots

### Executive Summary

![Executive Summary](Visualizations/dashboard_page1.png)

### Regions and Returns

![Regions and Returns](Visualizations/dashboard_page2.png)

---

## Limitations

- Every order contains a single product line, so basket analysis is not possible.
- The dataset has no sales targets or budgets, so there is no actual-vs-target comparison.
- 2026 contains data only up to September, so full-year comparisons with 2026 would be misleading.
- About 20% of orders are dated before the customer's signup date, so signup-to-first-order time was not analysed.
- Customer names are not unique (330 names for 620 customers), so analysis uses Customer ID.

---

## Project Folder Structure

```text
ShopSphere_Project/
│
├── README.md
│
├── Dataset/
│   ├── Raw/
│   │   ├── shopsphere_customers.csv
│   │   ├── shopsphere_date_dim.csv
│   │   ├── shopsphere_products.csv
│   │   └── shopsphere_sales_fact.csv
│   └── Cleaned/
│       └── shopsphere_sales_clean.xlsx
│
├── SQL/
│   ├── shopsphere_full_setup.sql
│   └── shopsphere_15_simple_questions.sql
│
├── PowerBI/
│   ├── ShopSphere_Dashboard.pbix
│   ├── ShopSphere_Theme.json
│   └── Assets/
│       ├── shopsphere_logo.png
│       ├── shopsphere_page_background.png
│       └── shopsphere_page_background_page2.png
│
└── Visualizations/
    ├── dashboard_page1.png
    └── dashboard_page2.png
```

---

## Author

- **Name:** Sameer Ahamed S
- **Student ID:** AF05323169
- **Organization:** Anudip Foundation
- **Course:** DBA_AI
- **Batch Code:** ANP - d76335
