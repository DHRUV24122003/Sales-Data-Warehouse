
-- Silver Layer: ERP Location


DROP TABLE IF EXISTS silver.erp_loc_a101;

--table created
CREATE TABLE silver.erp_loc_a101 AS
SELECT
    REPLACE("CID", '-', '') AS cid, --dash is removed
    "CNTRY" AS cntry
FROM bronze.erp_loc_a101;


select * from silver.erp_loc_a101 ;


