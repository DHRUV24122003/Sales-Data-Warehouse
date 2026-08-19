    select * from bronze.crm_cust_info;
    select * from bronze.crm_sales_details;

    


    -- Top 10 Highest Sales Orders with Customer Name & Gender

    select 
        s.sls_ord_num,
        c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
        c.cst_gndr,
        s.sls_sales
        FROM bronze.crm_sales_details s
        INNER JOIN bronze.crm_cust_info c
        ON s.sls_cust_id = c.cst_id

        ORDER BY s.sls_sales DESC
        LIMIT 10;




--Same as Above (Slightly Different Writing Style)
    select s.sls_ord_num,
            
        c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,  -- we can join multiple coulumns like this of a same table or different tables
        c.cst_gndr,
        s.sls_sales
        from bronze.crm_sales_details s
        Inner JOIN bronze.crm_cust_info  c
        ON s.sls_cust_id = c.cst_id
        ORDER by  s.sls_sales  DESC limit 10;


    --find out the total sales amount of each and every customer
    select c.cst_id,
        c.cst_firstname || ' ' || c.cst_lastname as cst_fullname,
        c.cst_gndr,
        sum(s.sls_sales) as total_sales
        from bronze.crm_sales_details s
        INNER JOIN bronze.crm_cust_info c
        ON s.sls_cust_id = c.cst_id
        group by c.cst_id, c.cst_firstname, c.cst_lastname,c.cst_gndr order by total_sales  desc;


    --All Customers with Their Orders (including those who never ordered)
    SELECT 
        c.cst_id,
        c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
        c.cst_gndr,
        s.sls_ord_num
    FROM bronze.crm_cust_info c
    LEFT JOIN bronze.crm_sales_details s 
        ON c.cst_id = s.sls_cust_id
    LIMIT 20;


--Customers Who Never Placed Any Order
    SELECT 
        c.cst_id,
        c.cst_firstname || ' ' || c.cst_lastname AS customer_name,
        c.cst_gndr
    FROM bronze.crm_cust_info c
    LEFT JOIN bronze.crm_sales_details s 
        ON c.cst_id = s.sls_cust_id
    WHERE s.sls_ord_num IS NULL          
    ORDER BY c.cst_id
    LIMIT 20;


    --total sales of individual products
    SELECT 
        p.prd_key,
        p.prd_nm AS product_name,
        SUM(s.sls_sales) AS total_sales
    FROM bronze.crm_sales_details s
    INNER JOIN bronze.crm_prd_info p 
        ON s.sls_prd_key = p.prd_key
    GROUP BY p.prd_key, p.prd_nm
    ORDER BY total_sales DESC;





--Har customer ka naam, country aur unki total sales dikhao.
--join info , sales details and location
select * from bronze.crm_cust_info
select * from bronze.crm_sales_details
select * from bronze.erp_loc_a101

SELECT
    c.cst_firstname,
    c.cst_lastname,
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY c.cst_firstname, c.cst_lastname, l."CNTRY"
ORDER BY total_sales DESC;



-- Har product ka naam, category, product line aur uski total sales + total quantity dikhao.
-- Sales ke hisaab se descending order mein.


select * from bronze.crm_prd_info
select * from bronze.crm_sales_details
select * from bronze.erp_px_cat_g1v2

SELECT DISTINCT "ID"
FROM bronze.erp_px_cat_g1v2
LIMIT 20;

SELECT DISTINCT RIGHT(prd_key, 10) AS prd_key_last10
FROM bronze.crm_prd_info

SELECT
    p.prd_nm AS product_name,
    pc."CAT" AS category,
    p.prd_line AS product_line,
    SUM(s.sls_sales) AS total_sales,
    SUM(s.sls_quantity) AS total_quantity
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_prd_info p
    ON s.sls_prd_key = RIGHT(p.prd_key, 10)
LEFT JOIN bronze.erp_px_cat_g1v2 pc
    ON REPLACE(LEFT(p.prd_key, 5), '-', '_') = pc."ID"
GROUP BY p.prd_nm, pc."CAT", p.prd_line
ORDER BY total_sales DESC;


--the customers who did not give any order
--their name gender and country
select * from bronze.crm_prd_info
select * from bronze.crm_sales_details
select * from bronze.erp_px_cat_g1v2
select * from bronze.crm_cust_info
select * from bronze.erp_loc_a101



SELECT
    c.cst_firstname,
    c.cst_lastname,
    c.cst_gndr AS gender,
    l."CNTRY" AS country
FROM bronze.crm_cust_info c
LEFT JOIN bronze.crm_sales_details s
    ON c.cst_id = s.sls_cust_id
LEFT JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
WHERE s.sls_cust_id IS NULL
ORDER BY c.cst_firstname;


-- Har country ka total sales, total orders aur total unique customers dikhao.
-- Highest sales wale country ko pehle dikhao.

select * from bronze.crm_prd_info
select * from bronze.crm_sales_details
select * from bronze.erp_px_cat_g1v2
select * from bronze.crm_cust_info
select * from bronze.erp_loc_a101


select l."CNTRY" as country,
       sum(s.sls_sales) as total_sales,
       count(s.sls_ord_num) as order_count,
       count(distinct(cst_id)) as unique_cst

    FROM bronze.crm_cust_info c
LEFT JOIN bronze.crm_sales_details s
    ON c.cst_id = s.sls_cust_id
LEFT JOIN bronze.erp_loc_a101 l
    ON REPLACE(l."CID", '-', '') = c.cst_key
    GROUP BY l."CNTRY" 

