select * from bronze.crm_cust_info;

select * from bronze.crm_cust_info limit 10;

select cst_firstname, cst_lastname, cst_gndr from bronze.crm_cust_info limit 15;


Select * from bronze.crm_cust_info where cst_gndr = 'M';
-- only male customers

select cst_id, cst_key, cst_firstname , cst_gndr from bronze.crm_cust_info Where cst_gndr = 'F'
--only female customers

select * from bronze.crm_prd_info;


select * from bronze.crm_prd_info where prd_line = 'R ' 

-- Full Details of Road Products

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_line = 'R '
ORDER BY prd_id;

----Correct Way to Filter Product Line 'R'
SELECT *
FROM bronze.crm_prd_info
WHERE TRIM(prd_line) = 'R'
LIMIT 5;


-- Orders with Quantity Greater than 1



Select * from bronze.crm_sales_details  where sls_quantity > 1 ;


--Newest Customers First

select * from bronze.crm_cust_info order by cst_create_date DESC  lIMIT 10;

--Newest Customers (Ignoring NULLs)
select * from bronze.crm_cust_info where  cst_create_date is not null order by cst_create_date DESC  lIMIT 10



-- Count of Customers by Marital Status
select cst_marital_status, count(*) from bronze.crm_cust_info group by cst_marital_status  ;


SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

--Top 5 Highest Prices
select * from bronze.crm_sales_details where sls_price IS NOT NULL order by sls_price desc limit 5;

-- if two different prices
SELECT DISTINCT ON (sls_price),*

FROM bronze.crm_sales_details where sls_price IS NOT NULL
ORDER BY sls_price DESC Limit 5


---Top 5 Distinct Highest Prices (using DISTINCT ON)

SELECT DISTINCT ON (sls_price)
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details where sls_price IS NOT NULL
ORDER BY sls_price DESC Limit 5;



---select distinct prices
SELECT DISTINCT ON (sls_price) *

FROM bronze.crm_sales_details
ORDER BY sls_price DESC, sls_ord_num limit 5


--Average Order Value
SELECT ROUND(AVG(sls_sales), 2) AS avg_order_value
FROM bronze.crm_sales_details;


select * from bronze.crm_sales_details
select * from bronze.erp_cust_az12;
select * from bronze.loc_a101;
select * from bronze.erp_px_cat_g1v2;





--ctes
SELECT *
FROM (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
) 
WHERE total_sales > 10000;




WITH customer_sales AS (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT *
FROM customer_sales
WHERE total_sales > 10000
ORDER BY total_sales DESC;





-- Q2. Product-wise total sales (> 50000)


WITH product_sales AS (
    SELECT 
        sls_prd_key,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_prd_key
)
SELECT *
FROM product_sales
WHERE total_sales > 50000
ORDER BY total_sales DESC;

 
 -- Year-wise total sales


WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS sales_year,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    WHERE LENGTH(sls_order_dt::TEXT) = 8
    GROUP BY sales_year
)
SELECT *
FROM yearly_sales
ORDER BY sales_year


--Customer total sales + Rank (without Window Function)

WITH customer_sales AS (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT 
    cs1.sls_cust_id,
    cs1.total_sales,
    (
        SELECT COUNT(*) + 1
        FROM customer_sales cs2
        WHERE cs2.total_sales > cs1.total_sales
    ) AS sales_rank
FROM customer_sales cs1
ORDER BY sales_rank;




-- Top 5 customers by sales + Name


WITH customer_sales AS (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT 
    c.cst_firstname,
    c.cst_lastname,
    cs.total_sales
FROM customer_sales cs
INNER JOIN bronze.crm_cust_info c
    ON cs.sls_cust_id = c.cst_id
ORDER BY cs.total_sales DESC
LIMIT 5;



-- Country-wise total sales
WITH country_sales AS (
    SELECT 
        l."CNTRY" AS country,
        SUM(s.sls_sales) AS total_sales
    FROM bronze.crm_sales_details s
    INNER JOIN bronze.crm_cust_info c
        ON s.sls_cust_id = c.cst_id
    LEFT JOIN bronze.erp_loc_a101 l
        ON REPLACE(l."CID", '-', '') = c.cst_key
    GROUP BY l."CNTRY"
)
SELECT *
FROM country_sales
ORDER BY total_sales DESC;




--Multiple CTEs (Product sales → Top 5)

WITH product_sales AS (
    SELECT 
        sls_prd_key,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_prd_key
),
top_products AS (
    SELECT *
    FROM product_sales
    ORDER BY total_sales DESC
    LIMIT 5
)
SELECT * FROM top_products;


-- Orders greater than Average Order Value

WITH avg_order AS (
    SELECT AVG(sls_sales) AS average_sales
    FROM bronze.crm_sales_details
)
SELECT 
    s.sls_ord_num,
    s.sls_prd_key,
    s.sls_cust_id,
    s.sls_sales
FROM bronze.crm_sales_details s
CROSS JOIN avg_order a
WHERE s.sls_sales > a.average_sales
ORDER BY s.sls_sales DESC;




-- Product Line wise total sales

WITH product_line_sales AS (
    SELECT 
        p.prd_line,
        SUM(s.sls_sales) AS total_sales
    FROM bronze.crm_sales_details s
    INNER JOIN bronze.crm_prd_info p
        ON s.sls_prd_key = RIGHT(p.prd_key, 10)
    GROUP BY p.prd_line
)
SELECT *
FROM product_line_sales
ORDER BY total_sales DESC;



-- Customers with more than 5 orders
WITH customer_orders AS (
    SELECT 
        sls_cust_id,
        COUNT(DISTINCT sls_ord_num) AS total_orders
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
    HAVING COUNT(DISTINCT sls_ord_num) > 5
)
SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    c.cst_gndr,
    co.total_orders
FROM customer_orders co
INNER JOIN bronze.crm_cust_info c
    ON co.sls_cust_id = c.cst_id
ORDER BY co.total_orders DESC;