select * from bronze.crm_cust_info
select * from bronze.crm_sales_details
select * from bronze.crm_prd_info

-- Q1. Average sales se zyada wali sales records dikhao.
SELECT 
    sls_prd_key,
    sls_sales
    
FROM bronze.crm_sales_details
WHERE sls_sales > (
    SELECT AVG(sls_sales) 
    FROM bronze.crm_sales_details   
)
ORDER BY sls_sales DESC
LIMIT 10;




--give the details of maximum  sales of an order
select * from bronze.crm_sales_details
where sls_sales = (select max(sls_sales) from bronze.crm_sales_details)
 limit 10


--the customer name who didn't give any order

SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    c.cst_gndr
FROM bronze.crm_cust_info c
LEFT JOIN bronze.crm_sales_details s 
    ON c.cst_id = s.sls_cust_id
WHERE s.sls_cust_id IS NULL;



--subquery in select statement
select cst_firstname,
cst_lastname
from bronze.crm_cust_info
where cst_id  not in (select distinct sls_cust_id from bronze.crm_sales_details where sls_cust_id is not null)



SELECT 
    cst_id,
    cst_firstname,
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_id NOT IN (
    SELECT DISTINCT sls_cust_id
    FROM bronze.crm_sales_details
    WHERE sls_cust_id IS NOT NULL
);