select * from bronze.crm_cust_info;


-- crm_cust_info total customer base
SELECT
    cst_gndr,
    COUNT(*) AS total
FROM bronze.crm_cust_info
GROUP BY cst_gndr
ORDER BY total DESC;


--cutomer count according to their marital status

select cst_marital_status,count(*) AS total
FROM bronze.crm_cust_info group by cst_marital_status


--total sales done
SELECT SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details;


-- Average order value  (average of sls_sales)

SELECT ROUND(AVG(sls_sales)::numeric, 2) AS avg_order_value
FROM bronze.crm_sales_details;

--or

SELECT ROUND(CAST(AVG(sls_sales) AS numeric), 2) AS avg_order_value
FROM bronze.crm_sales_details;



-- Total Sales of each product (Highest first)
SELECT
    sls_prd_key,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
GROUP BY sls_prd_key
ORDER BY total_sales DESC;


--toal sales of each product in desc order
select sls_prd_key , sum(sls_sales)  As total_sales from bronze.crm_sales_details  group by sls_prd_key order by total_sales
desc


--Average sales of each product (sls_sales average).

select sls_prd_key, avg(sls_sales) as average_sales from bronze.crm_sales_details group by sls_prd_key order by average_sales
desc;

--round is used for round off
select round(avg(sls_sales)) as average_sales from bronze.crm_sales_details  order by average_sales
desc

--Product Total Sales (with filter)

SELECT sls_prd_key, SUM(sls_sales) AS total_sales 
FROM bronze.crm_sales_details 
GROUP BY sls_prd_key
HAVING SUM(sls_sales) > 50000 
ORDER BY total_sales DESC;


--Customer Count by Gender + Marital Status
SELECT cst_gndr, cst_marital_status, COUNT(*) AS total_customers 
FROM bronze.crm_cust_info 
GROUP BY cst_gndr, cst_marital_status
ORDER BY total_customers DESC;

-- Average Cost by Product Line

SELECT prd_line, AVG(prd_cost) AS avg_cost  
FROM bronze.crm_prd_info 
GROUP BY prd_line 
ORDER BY avg_cost DESC;



--Highest and Lowest Product Cost

SELECT
    MAX(prd_cost) AS highest_price,
    MIN(prd_cost) AS lowest_price
FROM bronze.crm_prd_info
WHERE prd_cost IS NOT NULL;





--Top 5 Distinct Highest Prices

SELECT DISTINCT prd_cost
FROM bronze.crm_prd_info 
WHERE prd_cost IS NOT NULL 
ORDER BY prd_cost DESC 
LIMIT 5;



--Top 5 Cheapest Products (Distinct Cost)
SELECT
    distinct on(prd_cost)
    prd_key,
    prd_nm,
    prd_cost,
    'Cheapest' AS category
FROM bronze.crm_prd_info
WHERE prd_cost IS NOT NULL
ORDER BY prd_cost ASC
LIMIT 5;


--Top 5 Most Expensive Products (Distinct Cost)
SELECT
    distinct on(prd_cost)
    prd_key,
    prd_nm,
    prd_cost,
    '   Most Expensive' AS category
FROM bronze.crm_prd_info
WHERE prd_cost IS NOT NULL
ORDER BY prd_cost DESC
LIMIT 5;



--Top 10 Highest Sales Orders with Customer Name

select s.sls_ord_num,
       c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,
       c.cst_gndr,
       s.sls_sales
       from bronze.crm_sales_details s
       Inner JOIN bronze.crm_cust_info  c
       ON sls_cust_id = cst_id
       ORDER by  s.sls_sales  DESC limit 10;

--Total Sales per Customer
select c.cst_id,
       c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,
       c.cst_gndr,
       sum(s.sls_sales) as total_sales
       from bronze.crm_sales_details s
       INNER JOIN bronze.crm_cust_info c
       ON s.sls_cust_id = c.cst_id
       group by c.cst_id, c.cst_firstname, c.cst_lastname,c.cst_gndr order by total_sales  desc



--Customers Who Never Placed an Order

SELECT
    c.cst_id,
    c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
    c.cst_gndr
FROM bronze.crm_cust_info c          -- Left Table (customers)
LEFT JOIN bronze.crm_sales_details s  -- Right Table (orders)
    ON c.cst_id = s.sls_cust_id
WHERE s.sls_ord_num IS NULL           -- Only NULL wale (no order)
ORDER BY c.cst_id;



--join the product and sales together and find out the total sales and name of the product
--prd key is common
SELECT p.prd_key, p.prd_nm AS product_name, SUM(s.sls_sales) AS total_sales
FROM bronze.crm_prd_info p
INNER JOIN bronze.crm_sales_details s ON s.sls_prd_key = SUBSTRING(p.prd_key FROM 7)
GROUP BY p.prd_key, p.prd_nm
ORDER BY total_sales DESC;





--Number of Customers per Country

SELECT l."CNTRY" AS country, COUNT(*) AS total_customers
FROM bronze.crm_cust_info c
INNER JOIN bronze.erp_loc_a101 l ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_customers DESC;





--total sales by location.


SELECT l."CNTRY" AS country, SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC;



--Top 5 Products by Sales
select p.prd_nm,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
       Inner Join bronze.crm_prd_info p
       ON   s.sls_prd_key = substring(p.prd_key from 7)
       group by p.prd_nm order by total_sales desc limit 5



--Total Sales by Gender
select c.cst_gndr,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
       INNER JOIN bronze.crm_cust_info c
       ON s.sls_cust_id = c.cst_id
       group by c.cst_gndr order by total_sales desc





-- Product line (prd_line) wise total sales
select p.prd_line,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
    INNER JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = substring(p.prd_key from 7)
    group by p.prd_line order by total_sales desc


--First Order Date + Total Sales per Customer
SELECT
    c.cst_id,
    c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
    MIN(s.sls_order_dt) AS first_order_date,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
GROUP BY c.cst_id, c.cst_firstname, c.cst_lastname
ORDER BY total_sales DESC;

--Sales by Product Category + Country

SELECT
    p.prd_line AS product_category,
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales,
    COUNT(*) AS total_orders
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = SUBSTRING(p.prd_key FROM 7)
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY p.prd_line, l."CNTRY"
ORDER BY total_sales DESC;


--Top 10 Countries by Performance
SELECT l."CNTRY" AS country,
       SUM(s.sls_sales) AS total_sales,
       COUNT(DISTINCT s.sls_ord_num) AS total_orders,
       COUNT(DISTINCT c.cst_id) AS total_customers
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_prd_info p ON s.sls_prd_key = SUBSTRING(p.prd_key FROM 7)
INNER JOIN bronze.crm_cust_info c ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC
LIMIT 10;


-- basic conversion


select cst_key,
      replace(cst_key,'AW','CUST') as new_key
      from bronze.crm_cust_info
      LIMIT 10;


select cst_key,
       left(cst_key,5) as first_5
        from bronze.crm_cust_info
limit 5;

select cst_key,
       right(cst_key,5) as last_5
        from bronze.crm_cust_info
limit 5;


--find from between
select cst_key,
       SUBSTRING(cst_key FROM 2 for 5) AS MIDDLE_PART
       FROM bronze.crm_cust_info
limit 5;



--date function

select sls_order_dt,
to_date(sls_order_dt::TEXT,'YYYYMMDD') as order_date
from bronze.crm_sales_details
limit 10;

--FIND OUT THE YEAR,MONTH,DAY (EXTRACT)
select
    to_date(sls_order_dt::TEXT,'YYYYMMDD') AS order_date, --convert first in date
    EXTRACT(YEAR FROM to_date(sls_order_dt::TEXT,'YYYYMMDD')) as order_year,
    extract(month from to_date(sls_order_dt::text,'YYYYMMDD')) as order_month,
    extract(day from to_date(sls_order_dt::text, 'YYYYMMDD')) as order_day
    from bronze.crm_sales_details
limit 10



--date formatting
select
    to_DATE(sls_order_dt :: TEXT ,'YYYYMMDD') AS ORDER_DATE,
    to_char(to_date(sls_order_dt::text,'YYYYMMDD'), 'DD-Mon-YYYY') as formatted_date
from bronze.crm_sales_details
limit 5


--year wise total sales
SELECT
    EXTRACT(YEAR FROM TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS order_year,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8          -- only valid 8-digit dates
GROUP BY order_year
ORDER BY order_year;





--Delivery Time (using AGE)

SELECT
    sls_ord_num,
    TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD') AS order_date,
    TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD') AS ship_date,
    AGE(
        TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD'),
        TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
    ) AS delivery_time
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
  AND LENGTH(sls_ship_dt::TEXT) = 8
LIMIT 10;


--date_trunc
SELECT
    DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS order_month,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY order_month
ORDER BY order_month;


--Month-wise Total Sales
SELECT
    TO_CHAR(DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')), 'YYYY-MM') AS order_month,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD'))
ORDER BY order_month;



--subquery
--Orders greater than Average Sales (Subquery)


select sls_prd_key,sls_sales
from bronze.crm_sales_details
where sls_sales > (
    select avg(sls_sales) from bronze.crm_sales_details
    )
order by sls_sales desc limit 10


--the customer who has a record over 100000 sales
--SQL
SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_id IN (
    SELECT sls_cust_id
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
    HAVING SUM(sls_sales) > 1000
);



--Top 10 Customers using CTE
WITH customer_sales AS (
    SELECT
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    cs.total_sales
FROM bronze.crm_cust_info c
INNER JOIN customer_sales cs
    ON c.cst_id = cs.sls_cust_id
ORDER BY cs.total_sales DESC
LIMIT 10;


--Top 5 Products using Multiple CTEs
WITH product_sales AS (
    SELECT sls_prd_key, SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_prd_key
),
top_products AS (
    SELECT * FROM product_sales
    ORDER BY total_sales DESC
    LIMIT 5
)
SELECT * FROM top_products;