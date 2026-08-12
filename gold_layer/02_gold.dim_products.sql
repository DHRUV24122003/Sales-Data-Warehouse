DROP TABLE IF EXISTS gold.dim_products;



CREATE TABLE gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,  -- Surrogate key
    p.prd_id AS product_id,
    p.prd_key AS product_number,
    p.prd_nm AS product_name,
    p.prd_cost AS product_cost,
    p.prd_line AS product_line,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    p.prd_start_dt AS start_date,
    p.prd_end_dt AS end_date
FROM silver.crm_prd_info p
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON p.prd_key = pc.id;



    SELECT * FROM gold.dim_products LIMIT 10;