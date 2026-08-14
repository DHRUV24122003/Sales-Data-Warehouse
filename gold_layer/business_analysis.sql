SELECT
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    SUM(sales_amount) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(sales_amount)::numeric, 2) AS avg_order_value
FROM gold.fact_sales;


--sales by country

SELECT
    c.country,
    COUNT(DISTINCT f.order_number) AS total_orders,
    COUNT(DISTINCT f.customer_key) AS total_customers,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;




-- 3. Sales by Gender


SELECT
    c.gender,
    COUNT(DISTINCT f.customer_key) AS total_customers,
    SUM(f.sales_amount) AS total_sales,
    ROUND(AVG(f.sales_amount)::numeric, 2) AS avg_sales
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_sales DESC;


-- 4. Top 10 Products by Revenue 
SELECT
    p.product_name,
    p.product_line,
    p.category,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name, p.product_line, p.category
ORDER BY total_sales DESC
LIMIT 10;



-- 5. Sales by Product Line + Category


SELECT
    p.product_line,
    p.category,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_line, p.category
ORDER BY total_sales DESC;



-- 6. Top 10 Customers by Spending


SELECT
    c.full_name,
    c.country,
    c.gender,
    SUM(f.sales_amount) AS total_spent,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.full_name, c.country, c.gender
ORDER BY total_spent DESC
LIMIT 10;






