-- ADVANCED DATA ANALYTICS

/* 
1. CHANGE OVER TIME

This is a technique used to analyze how a measure evolves over time.
It helps to track the trend and identify seasonality in your data

*** FORMULA ***

[Measure] By [Date Dimension]

Example:  Total Sales By Year, Average Cost By Month
*/

-- ANALYZE SALES PERFOMANCE OVER TIME


-- A day overview of sales
SELECT
order_date,
SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date


-- A year overview of sales

SELECT
YEAR(order_date) as order_year,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


-- Sales overview over month ( Changes Over Months)

SELECT

MONTH(order_date) as order_month,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY  MONTH(order_date)
ORDER BY  MONTH(order_date)

-- Now overall overview

SELECT
YEAR(order_date) as order_year,
MONTH(order_date) as order_month,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


-- Some formats

SELECT
DATETRUNC(month, order_date) as order_date,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)


