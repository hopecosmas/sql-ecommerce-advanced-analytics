/* 
2. CUMULATIVE ANALYSIS

This involves aggregating the data progressively over time.
This helps us understand how our business is growing/declining over the time

*** FORMULA ****

[Cumulative Measure] By [Date Dimension]

Example: Running Total Sales By Year, Moving Average of Sales by Month
*/


-- Calculate the total sales per month and the running total of sales over time.

SELECT
order_date,
total_sales,
-- window function
SUM(total_sales) OVER (ORDER BY order_date ) as running_total_sales
FROM 
(
SELECT
DATETRUNC(month, order_date) as order_date,
SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
) t



-- Adding Moving Average Price

SELECT
order_date,
total_sales,
avg_price,
-- window function
SUM(total_sales) OVER (ORDER BY order_date ) as running_total_sales,
AVG(avg_price) OVER (ORDER BY order_date ) as moving_average_price
FROM 
(
SELECT
DATETRUNC(month, order_date) as order_date,
SUM(sales_amount) as total_sales,
AVG(price) as avg_price
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
) t

