/* 

--- DATA SEGMENTATION

Here we group the data based on a specific range.
It helps to understand the correlation between two measures.

*** FORMULA ****

[Measure] By [Measure]

Example:  Total products By Sales Range, Total Customers By Age

*/

-- Segment products into cost ranges and count how many products fall into each segment


WITH product_segments AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
     ELSE 'Above 1000'
END cost_range
FROM [gold.dim_products]
)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC



-- CASE 2: Group customers into three segments based on their spending behaviour
    -- VIP: At least 12 months of history and spending more than 5,000
    -- Regular: At least 12 months of history but spending 5,000 or less
    -- New: Lifespan less than 12 months
-- And find the total number of customers by each group


WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS months_lifespan
FROM [gold.fact_sales] f 
LEFT JOIN [gold.dim_customers] c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)


SELECT 
customer_segment,
COUNT(customer_key) AS total_customer
FROM (
SELECT
customer_key,
total_spending,
months_lifespan,
CASE WHEN months_lifespan > 12 AND total_spending > 5000 THEN 'VIP'
     WHEN months_lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
     ELSE 'New'
END customer_segment
FROM customer_spending
) t 
GROUP BY customer_segment
ORDER BY total_customer DESC