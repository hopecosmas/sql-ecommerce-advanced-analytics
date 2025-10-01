/* 

3. PERFORMANCE ANALYSIS

This involves comparing the current value with the target value. 
This helps businesses to measure success and compara performance

**** FORMULA ****

Current [Measure] - Target [Measure] 

Example: Current Sales - Average Sales, Current Year Sales - Previous Year Sales etc


*/

-- Analyze the yearly performance of products by comparing each product's sales to both
-- its average sales performance and the previous year's sales.


-- This parts analyses the yearly performance of each product.
SELECT
YEAR (f.order_date) as order_year,
p.product_name,
SUM(f.sales_amount) as current_sales
FROM [gold.fact_sales] f
LEFT JOIN [gold.dim_products] p 
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR (f.order_date), p.product_name;


-- To compare with it's average sales performance and previous yeat's performance, we use CTE

WITH yearly_product_sales AS (

SELECT
YEAR (f.order_date) as order_year,
p.product_name,
SUM(f.sales_amount) as current_sales
FROM [gold.fact_sales] f
LEFT JOIN [gold.dim_products] p 
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR (f.order_date), p.product_name

) 

SELECT
order_year,
product_name,
current_sales,
-- for avg sales use AVG function, since we want products, we partition by product_name
AVG(current_sales) OVER (PARTITION BY product_name) as avg_sales,
current_sales -  AVG(current_sales) OVER (PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales -  AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN current_sales -  AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'Avg'
END avg_change,
-- Year-over-year Analysis
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_year_sales,
CASE WHEN current_sales -  LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
     WHEN current_sales -  LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
     ELSE 'No Change'
END prev_year_change
FROM yearly_product_sales
ORDER BY  product_name, order_year;