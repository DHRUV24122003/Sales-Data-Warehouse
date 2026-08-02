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