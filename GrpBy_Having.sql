select * from bronze.crm_cust_info;


-- crm_cust_info table mein total kitne customers hain?
SELECT
    cst_gndr,
    COUNT(*) AS total
FROM bronze.crm_cust_info
GROUP BY cst_gndr
ORDER BY total DESC;


select cst_gndr, count(*) As total from bronze.crm_cust_info GROUP BY cst_gndr  ORDER BY total DESC;

-- Marital Status ke hisaab se customers count karo.
select cst_marital_status,count(*) AS total
FROM bronze.crm_cust_info group by cst_marital_status


SELECT SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details;


-- Average order value nikaalo (sls_sales ka average).

SELECT ROUND(AVG(sls_sales), 2) AS avg_order_value
FROM bronze.crm_sales_details;



-- Har Product ka Total Sales (Highest pehle)
SELECT
    sls_prd_key,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
GROUP BY sls_prd_key
ORDER BY total_sales DESC;

select * from bronze.crm_sales_details;

--total sales
select sum(sls_sales) from bronze.crm_sales_details

select sls_prd_key , sum(sls_sales)  As total_sales from bronze.crm_sales_details  group by sls_prd_key order by total_sales
desc

--Average order value nikaalo (sls_sales ka average).


select sls_prd_key, avg(sls_sales) as average_sales from bronze.crm_sales_details group by sls_prd_key order by average_sales
desc;

--round is used for round off
select round(avg(sls_sales)) as average_sales from bronze.crm_sales_details  order by average_sales
desc

--har product ka total sales

select sls_prd_key, sum(sls_sales) as total_sales from bronze.crm_sales_details group by sls_prd_key
     having sum(sls_sales)> 50000 order by total_sales desc

--Gender + Marital Status dono ke combination se customers count karo.

select cst_gndr, cst_marital_status , count(*) as total_customers from bronze.crm_cust_info group by cst_gndr, cst_marital_status
order by total_customers desc;

--Q9. crm_prd_info table se har prd_line ka average cost nikaalo.
select * from bronze.crm_prd_info;

select  prd_line, avg(prd_cost) avg_cost  from bronze.crm_prd_info group by prd_line order by avg_cost desc

--sabse mahanga aur sabse sasta product

SELECT
    MAX(prd_cost) AS highest_price,
    MIN(prd_cost) AS lowest_price
FROM bronze.crm_prd_info
WHERE prd_cost IS NOT NULL;





select distinct prd_cost

from bronze.crm_prd_info where prd_cost IS NOT NULL order by prd_cost desc limit 5




--5 sabse saste
-- Top 5 Sabse Saste Products(agar product cost distinct chahiye to)
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


--sabse mahange
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



select * from bronze.crm_cust_info;
select * FROM bronze.crm_sales_details;

select s.sls_ord_num,
       c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,
       c.cst_gndr,
       s.sls_sales
       from bronze.crm_sales_details s
       Inner JOIN bronze.crm_cust_info  c
       ON sls_cust_id = cst_id
       ORDER by  s.sls_sales  DESC limit 10;

--
select c.cst_id,
       c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,
       c.cst_gndr,
       sum(s.sls_sales) as total_sales
       from bronze.crm_sales_details s
       INNER JOIN bronze.crm_cust_info c
       ON s.sls_cust_id = c.cst_id
       group by c.cst_id, c.cst_firstname, c.cst_lastname,c.cst_gndr order by total_sales  desc




SELECT
    c.cst_id,
    c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
GROUP BY c.cst_id, c.cst_firstname, c.cst_lastname
ORDER BY total_sales DESC
LIMIT 10;



SELECT
    c.cst_id,
    c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
    c.cst_gndr
FROM bronze.crm_cust_info c          -- Left Table (saare customers)
LEFT JOIN bronze.crm_sales_details s  -- Right Table (orders)
    ON c.cst_id = s.sls_cust_id
WHERE s.sls_ord_num IS NULL           -- Sirf NULL wale (no order)
ORDER BY c.cst_id;

--join the product and sales together and find out the total sales and name of the product

select * from bronze.crm_prd_info;
select * from bronze.crm_sales_details;
--prd key is common
select p.prd_key,
       p.prd_nm,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
left join bronze.crm_prd_info p
ON   s.sls_prd_key = p.prd_key where p.prd_key IS NOT NULL GROUP BY p.prd_key, p.prd_nm
ORDER BY total_sales DESC;


SELECT
    p.prd_key,
    p.prd_nm AS product_name,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_prd_info p
INNER JOIN bronze.crm_sales_details s
    ON  p.prd_key =  s.sls_prd_key
GROUP BY p.prd_key, p.prd_nm
ORDER BY total_sales DESC;


SELECT
    p.prd_key,
    p.prd_nm AS product_name,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_prd_info p
INNER JOIN bronze.crm_sales_details s
    ON p.prd_key = s.sls_prd_key
GROUP BY p.prd_key, p.prd_nm
ORDER BY total_sales DESC;



--Customer + Location join karke har country mein kitne customers hain, count karo.

select * from bronze.erp_loc_a101;
select * from bronze.erp_cust_az12;

select CNTRY,
       COUNT(CID) as total_customers
       From bronze.erp_loc_a101 l
       INNER JOIN bronze.erp_cust_az12 c
       ON CID.c = CID.l
    group by CNTRY


SELECT
    l.CNTRY AS country,
    COUNT(*) AS total_customers
FROM bronze.crm_cust_info c
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(CID, '-', '') = c.cst_key
GROUP BY l.CNTRY
ORDER BY total_customers DESC;


SELECT
    l."CNTRY" AS country,
    COUNT(*) AS total_customers
FROM bronze.crm_cust_info c
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_customers DESC;







--Sales + Customer + Location join karke har country ka total sales amount nikaalo.


SELECT
    l."CNTRY" AS country,
    sum(sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key =
GROUP BY l."CNTRY"
ORDER BY total_customers DESC;



SELECT
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC;




select l."CNTRY" as country,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
    INNER JOIN bronze.crm_cust_info c
    ON  s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    on REPLACE(l."CID",'-',' ') = c.cst_key
group by l.CNTRY order by total_sales desc


select p.prd_nm,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
       Inner Join bronze.crm_prd_info p
       ON   s.sls_prd_key = substring(p.prd_key from 7)
       group by p.prd_nm order by total_sales desc limit 5



select * from bronze.crm_prd_info
select * from bronze.erp_loc_a101;
select * from bronze.crm_cust_info;
select * from bronze.crm_sales_details;

select c.cst_gndr,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
       INNER JOIN bronze.crm_cust_info c
       ON s.sls_cust_id = c.cst_id
       group by c.cst_gndr order by total_sales desc





-- Product line (prd_line) wise total sales nikaalo.
select p.prd_line,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
    INNER JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = substring(p.prd_key from 7)
    group by p.prd_line order by total_sales desc


--har customer ka first order date and total sales amount nikalo
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

--Q12. Product category (prd_line) aur country wise sales analysis karo.

select l.cntry as country,
       p.prd_line,
       sum(sls_sales) as total_sales
       from bronze.crm_sales_details s
       INNER JOIN bronze.crm_prd_info p
    ON p.PRD_KEY = s.sls_prd_key
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC;



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



SELECT
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales,
    COUNT(DISTINCT s.sls_ord_num) AS total_orders,
    COUNT(DISTINCT c.cst_id) AS total_customers
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = SUBSTRING(p.prd_key FROM 7)
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC
LIMIT 10;


-- today


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
WHERE LENGTH(sls_order_dt::TEXT) = 8          -- Sirf valid 8-digit dates
GROUP BY order_year
ORDER BY order_year;



--age()
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

SELECT
    TO_CHAR(DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')), 'YYYY-MM') AS order_month,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD'))
ORDER BY order_month;



SELECT
    DATE_TRUNC('month', TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD'))::DATE AS order_month,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY order_month
ORDER BY order_month;



--subquery
--Question: Un products ki sales dikhao jinki sales average sales se zyada hai.

select sls_prd_key,sls_sales
from bronze.crm_sales_details
where sls_sales > (
    select avg(sls_sales) from bronze.crm_sales_details
    )
order by sls_sales desc limit 10


--Question: Un customers ki details dikhao jinhone 100000 se zyada sales kiya hai.
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