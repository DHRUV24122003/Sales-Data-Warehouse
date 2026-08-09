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


