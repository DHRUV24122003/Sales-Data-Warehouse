-- =============================================
-- Silver Layer: CRM Product Info
-- =============================================

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info AS
SELECT
    prd_id,
    
    -- Clean Product Key (last part for joining with sales)
    SUBSTRING(prd_key FROM 7) AS prd_key,
    
    prd_nm,
    
    COALESCE(prd_cost, 0) AS prd_cost,
    
    TRIM(prd_line) AS prd_line,
    
    prd_start_dt,
    prd_end_dt

FROM bronze.crm_prd_info;


select * from silver.crm_prd_info. --details from the table


