-- =============================================
-- Silver Layer: ERP Customer AZ12
-- =============================================

DROP TABLE IF EXISTS silver.erp_cust_az12;



CREATE TABLE silver.erp_cust_az12 AS
SELECT
    "CID" AS cid,
    "BDATE" AS bdate,
    
    CASE 
        WHEN UPPER(TRIM("GEN")) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM("GEN")) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12;


select * from silver.erp_cust_az12