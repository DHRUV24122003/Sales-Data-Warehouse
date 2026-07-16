select * from bronze.crm_cust_info;

select * from bronze.crm_cust_info limit 10;

select cst_firstname, cst_lastname, cst_gndr from bronze.crm_cust_info limit 15;


Select * from bronze.crm_cust_info where cst_gndr = 'M';
-- only male customers

select cst_id, cst_key, cst_firstname , cst_gndr from bronze.crm_cust_info Where cst_gndr = 'F'
--only female customers

select * from bronze.crm_prd_info;

select * from bronze.crm_prd_info where prd_line = 'R '

-- crm_prd_info table se sirf woh products dikhao jinka prd_line = 'R' (Road bikes?).

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


SELECT *
FROM bronze.crm_prd_info
WHERE TRIM(prd_line) = 'R'
LIMIT 5;


-- crm_sales_details table se woh orders dikhao jisme sls_quantity > 1 hai

SELECT * from bronze.crm_sales_details;

Select * from bronze.crm_sales_details  where sls_quantity > 1 ;


-- Customers ko unke cst_create_date ke hisaab se newest first sort karke top 10 dikhao

select * from bronze.crm_cust_info order by cst_create_date DESC  lIMIT 10;


select * from bronze.crm_cust_info where  cst_create_date is not null order by cst_create_date DESC  lIMIT 10



-- Q9. crm_cust_info table mein se unique cst_marital_status values nikalo.
select cst_marital_status, count(*) from bronze.crm_cust_info group by cst_marital_status  ;


SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;


select * from bronze.crm_sales_details where sls_price IS NOT NULL order by sls_price desc limit 5;

-- agar alag alag price chahiye to
SELECT DISTINCT ON (sls_price),*

FROM bronze.crm_sales_details where sls_price IS NOT NULL
ORDER BY sls_price DESC Limit 5


---
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



---
SELECT DISTINCT ON (sls_price) *

FROM bronze.crm_sales_details
ORDER BY sls_price DESC, sls_ord_num limit 5

