--Trim function -> removes extra spaces from a  data colummn
-- LTRIM() / RTRIM()
-- LTRIM() → Sirf left side ke spaces hataata hai
-- RTRIM() → Sirf right side ke spaces hataata hai

Select cst_firstname,
TRIM(cst_firstname) AS cleaned_firstname
FROM bronze.crm_cust_info limit 10

--Upper() and Lower() -> Poori string ko Capital/Lower Letters mein convert karta hai.
SELECT 
    cst_firstname,
    UPPER(cst_firstname) AS upper_name,
    LOWER(cst_firstname) AS lower_name
FROM bronze.crm_cust_info
LIMIT 5;


--Length function -> Returns the length of a string
SELECT 
    cst_firstname,
    LENGTH(TRIM(cst_firstname)) AS name_length
FROM bronze.crm_cust_info
LIMIT 10;

--if we want to replace a string with another string, we can use the REPLACE() function.
select cst_key,
      replace(cst_key,'AW','CUST') as new_key
      from bronze.crm_cust_info
      LIMIT 10;

--SUBSTRING() / LEFT() / RIGHT()

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



---CONCAT() -> Concatenate two or more strings together
select cst_firstname,
       cst_lastname,
       CONCAT(cst_firstname,' ',cst_lastname) AS full_name
       FROM bronze.crm_cust_info
limit 5;

---CONCAT_WS() -> Concatenate two or more strings together with a separator
select cst_firstname,
       cst_lastname,
       CONCAT_WS(' ',cst_firstname,cst_lastname) AS full_name
       FROM bronze.crm_cust_info
limit 5;


--POSITION() / STRPOS() -> Returns the position of a substring in a string
select cst_firstname,
       POSITION('a' IN cst_firstname) AS position_a,
       STRPOS(cst_firstname,'a') AS strpos_a        
        FROM bronze.crm_cust_info
limit 5;




--date functions
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


