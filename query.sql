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




