
-- Silver Layer: CRM Customer Info


CREATE SCHEMA IF NOT EXISTS silver; --create schema for silver layer

DROP TABLE IF EXISTS silver.crm_cust_info; --delete table if already exist

CREATE TABLE silver.crm_cust_info AS
SELECT
    cst_id,
    cst_key,
    
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    TRIM(cst_firstname) || ' ' || TRIM(cst_lastname) AS full_name,
    
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,
    
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) IN ('S', 'SINGLE') THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) IN ('M', 'MARRIED') THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    
    cst_create_date

FROM bronze.crm_cust_info;


SELECT * FROM silver.crm_cust_info 


SELECT cst_gndr, COUNT(*) FROM silver.crm_cust_info GROUP BY cst_gndr;


--removing duplicate id'd of cutomer who are there more then once
SELECT cst_id, COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


--