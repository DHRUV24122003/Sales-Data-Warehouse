create DATABASE warehouse;
USE warehouse;
    create schema bronze;
    create schema silver;
    create schema gold;

CREATE TABLE bronze.crm_cust_info (
    customer_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);



CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm  VARCHAR(50),
    prd_cost INT,
    prd_line varchar(50),
    prd_start_dt TIMESTAMP,
    prd_end_dt TIMESTAMP

)


CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

CREATE TABLE bronze.erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50)
);




CREATE TABLE bronze.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
);


CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);


-- BULK INSERT bronze.crm_cust_info
-- FROM '/Users/dhruvkhanna/Documents/data_warehouse_project/datasets/source_crm/cust_info.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );


-- upar wala old method hai\



-- Best way to import CSV in Postgres


\copy bronze.crm_cust_info
FROM '/Users/dhruvkhanna/Documents/data_warehouse_project/datasets/source_crm/cust_info.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

\copy bronze.crm_prd_info
FROM '/Users/dhruvkhanna/Documents/data_warehouse_project/datasets/source_crm/prd_info.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

\copy bronze.crm_sales_details
FROM '/Users/dhruvkhanna/Documents/data_warehouse_project/datasets/source_crm/sales_details.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');




-- \copy bronze.erp_loc_a101
-- FROM '/Users/dhruvkhanna/Documents/data_warehouse_project/datasets/source_erp/loc_a101.csv'
-- WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');





SELECT * FROM loc_a101;

SELECT * FROM bronze.crm_cust_info;
SELECT * FROM bronze.crm_prd_info;
SELECT * FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.crm_sales_details;



select customer_id,
count(*)
from bronze.crm_cust_info
group by customer_id
having count(*) > 1 or customer_id is null;


select * ,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY cst_create_date DESC) AS flag_last
from bronze.crm_cust_info
where customer_id = 29466;


select * from bronze.crm_prd_info;



SELECT 
    p.prd_key,
    p.prd_nm AS product_name,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_prd_info p 
    ON s.sls_prd_key = SUBSTRING(p.prd_key FROM 7)
GROUP BY p.prd_key, p.prd_nm
ORDER BY total_sales DESC;


--Customer + Location join karke har country mein kitne customers hain, count karo.

SELECT
    l."CNTRY" AS country,
    COUNT(*) AS total_customers
FROM bronze.crm_cust_info c
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_customers DESC;


select * from bronze.erp_loc_a101
select * from bronze.crm_cust_info



--Sales + Customer + Location join karke har country ka total sales amount nikaalo.
SELECT
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC;

