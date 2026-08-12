
-- Silver Layer: CRM Sales Details


DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details AS
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    
    -- Date Conversion (BIGINT → DATE)
    CASE 
        WHEN LENGTH(sls_order_dt::TEXT) = 8 THEN TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
        ELSE NULL
    END AS sls_order_dt,
    
    CASE 
        WHEN LENGTH(sls_ship_dt::TEXT) = 8 THEN TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD') --ship date - same
        ELSE NULL
    END AS sls_ship_dt,
    
    CASE 
        WHEN LENGTH(sls_due_dt::TEXT) = 8 THEN TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD') --due date - same 
        ELSE NULL
    END AS sls_due_dt,
    
    sls_sales,
    sls_quantity,
    sls_price

FROM bronze.crm_sales_details;


SELECT * FROM silver.crm_sales_details LIMIT 10;


SELECT --total valid order dates
    COUNT(*) AS total_rows,
    COUNT(sls_order_dt) AS valid_order_dates
FROM silver.crm_sales_details;