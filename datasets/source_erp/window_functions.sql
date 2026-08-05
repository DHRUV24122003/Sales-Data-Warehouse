--rank with the total sales of the customer
SELECT 
    sls_cust_id,
    SUM(sls_sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(sls_sales) DESC) AS sales_rank
FROM bronze.crm_sales_details
GROUP BY sls_cust_id
ORDER BY sales_rank



-- Product-wise Sales Rank


SELECT 
    sls_prd_key,
    SUM(sls_sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(sls_sales) DESC) AS sales_rank
FROM bronze.crm_sales_details
GROUP BY sls_prd_key
ORDER BY sales_rank
LIMIT 10;



--Gender-wise Sales Rank (PARTITION BY ke saath)
SELECT 
    c.cst_gndr,
    c.cst_id,
    SUM(s.sls_sales) AS total_sales,
    RANK() OVER (PARTITION BY c.cst_gndr ORDER BY SUM(s.sls_sales) DESC) AS gender_rank
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c 
    ON s.sls_cust_id = c.cst_id
GROUP BY c.cst_gndr, c.cst_id
ORDER BY c.cst_gndr, gender_rank;




--Year-wise Rank
SQLSELECT 
    EXTRACT(YEAR FROM TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS sales_year,
    SUM(sls_sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(sls_sales) DESC) AS year_rank
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY sales_year
ORDER BY year_rank;





--RANK vs DENSE_RANK difference dekhne ke liye
 SELECT
    sls_cust_id,
    SUM(sls_sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(sls_sales) DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY SUM(sls_sales) DESC) AS dense_rank
FROM bronze.crm_sales_details
GROUP BY sls_cust_id
ORDER BY total_sales DESC
LIMIT 10;




-- ROW_NUMBER()
-- Kya Karta Hai?
-- Har row ko unique number deta hai (1, 2, 3, 4...), chahe values same hon.

SELECT 
    sls_cust_id,
    SUM(sls_sales) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(sls_sales) DESC) AS row_num
FROM bronze.crm_sales_details
GROUP BY sls_cust_id
ORDER BY row_num
LIMIT 10;



SELECT 
    c.cst_gndr,
    c.cst_id,
    SUM(s.sls_sales) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY c.cst_gndr ORDER BY SUM(s.sls_sales) DESC) AS row_num
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c 
    ON s.sls_cust_id = c.cst_id
GROUP BY c.cst_gndr, c.cst_id
ORDER BY c.cst_gndr, row_num;



--lag() and lead()
SELECT 
    sls_ord_num,
    sls_sales,
    LAG(sls_sales, 1) OVER (ORDER BY sls_ord_num) AS previous_sales,
    sls_sales - LAG(sls_sales, 1) OVER (ORDER BY sls_ord_num) AS difference
FROM bronze.crm_sales_details
ORDER BY sls_ord_num
LIMIT 15;


--lead()
SELECT 
    sls_ord_num,
    sls_sales,
    LEAD(sls_sales, 1) OVER (ORDER BY sls_ord_num) AS next_sales
FROM bronze.crm_sales_details
ORDER BY sls_ord_num
LIMIT 10;