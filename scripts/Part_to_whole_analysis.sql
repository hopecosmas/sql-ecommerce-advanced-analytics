/* 
--- PART-TO-WHOLE ANALYSIS

This analysis is used to analyze how an individual part is performing compared to the overall.
It allows us to understand which category has the greatest impact on the business.


****** FORMULA ******

([Measure / Total [Measure]) * 100 By [Dimension]

Example:  (Sales / Total sales ) * 100 By Category
*/


--- Which categories contribute the most to overall sales


WITH category_sales AS (
SELECT
category,
SUM(sales_amount) as total_sales
FROM [gold.fact_sales] f 
LEFT JOIN [gold.dim_products] p 
ON f.product_key = p.product_key
GROUP BY category
)

SELECT
category,
total_sales,
-- use window function to get the sum of sales in all categories
SUM(total_sales) OVER () AS overall_sales,
CONCAT ( ROUND ( (CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2),  '%' ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

