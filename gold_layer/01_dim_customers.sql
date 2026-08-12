CREATE SCHEMA IF NOT EXISTS gold;



DROP TABLE IF EXISTS gold.dim_customers;


CREATE TABLE gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,  -- Surrogate key
    c.cst_id AS customer_id,
    c.cst_key AS customer_number,
    c.cst_firstname AS first_name,
    c.cst_lastname AS last_name,
    c.full_name,
    c.cst_gndr AS gender,
    c.cst_marital_status AS marital_status,
    l.cntry AS country,
    c.cst_create_date AS create_date
FROM silver.crm_cust_info c
LEFT JOIN silver.erp_loc_a101 l
    ON c.cst_key = l.cid;



SELECT * FROM gold.dim_customers LIMIT 10;