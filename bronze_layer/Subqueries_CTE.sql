--Basic Table Checks
select * from bronze.crm_cust_info
select * from bronze.crm_sales_details
select * from bronze.crm_prd_info
select * from bronze.erp_loc_a101

-- Sales higher than Average
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




--give the details of maximum  sales of an order
select * from bronze.crm_sales_details
where sls_sales = (select max(sls_sales) from bronze.crm_sales_details)
 limit 10


--the customer name who didn't give any order

SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    c.cst_gndr
FROM bronze.crm_cust_info c
LEFT JOIN bronze.crm_sales_details s 
    ON c.cst_id = s.sls_cust_id
WHERE s.sls_cust_id IS NULL;



--Alternative (using NOT IN Subquery)
select cst_firstname,
cst_lastname
from bronze.crm_cust_info
where cst_id  not in (select distinct sls_cust_id from bronze.crm_sales_details where sls_cust_id is not null)





-- Products Cheaper than Average Cost
select * from bronze.crm_prd_info
where prd_cost <(select avg(prd_cost) from bronze.crm_prd_info where prd_cost is not null)


-- Most Expensive Product

select prd_id,prd_nm,prd_cost
from bronze.crm_prd_info
where prd_cost =(select max(prd_cost) from bronze.crm_prd_info where prd_cost is not null) 


--Customers with Total Sales > 10,000


select * from bronze.crm_cust_info
where cst_id in (select sls_cust_id from bronze.crm_sales_details group by sls_cust_id having sum(sls_sales) > 10000)







--Products with Above Average Total Sales

select sls_prd_key,
sum(sls_sales) as total_sales
from bronze.crm_sales_details
group by sls_prd_key
having sum(sls_sales) > (select avg(product_total) from (select sum(sls_sales) as product_total from bronze.crm_sales_details group by sls_prd_key) ) order by total_sales desc limit 10


---SELECT c.cst_id, c.cst_firstname, c.cst_lastname
FROM bronze.crm_cust_info c
WHERE c.cst_id IN (
    SELECT sls_cust_id
    FROM (
        SELECT sls_cust_id, COUNT(sls_ord_num) AS total_orders
        FROM bronze.crm_sales_details
        GROUP BY sls_cust_id
        ORDER BY total_orders DESC
        LIMIT 5
    ) t
);



SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname
FROM bronze.crm_cust_info c
WHERE c.cst_id IN (
    SELECT sls_cust_id
    FROM (
        SELECT 
            sls_cust_id,
            COUNT(sls_ord_num) AS total_orders
        FROM bronze.crm_sales_details
        GROUP BY sls_cust_id
        ORDER BY total_orders DESC
        LIMIT 5
    ) t
);


--Q9. Products That Were Never Sold.

select * from bronze.crm_prd_info
WHERE SUBSTRING(prd_key FROM 7) NOT IN (select distinct sls_prd_key from bronze.crm_sales_details where sls_prd_key is not null)


--.Customers Who Exist in Sales Table (using EXISTS)
select * from bronze.crm_cust_info c
where exists( select sls_cust_id from bronze.crm_sales_details s where s.sls_cust_id = c.cst_id)


-- Rank Customers by Total Sales (using Subquery)
SELECT 
    sls_cust_id,
    total_sales,
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT sls_cust_id, SUM(sls_sales) AS sales
            FROM bronze.crm_sales_details
            GROUP BY sls_cust_id
        ) t2
        WHERE t2.sales > t1.total_sales
    ) AS rank
FROM (
    SELECT 
        sls_cust_id, 
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
) t1
ORDER BY total_sales DESC;


--12  Orders Higher than Product’s Average Sales (Correlated Subquery)

SELECT 
    s.sls_ord_num,
    s.sls_prd_key,
    s.sls_sales
FROM bronze.crm_sales_details s
WHERE s.sls_sales > (
    SELECT AVG(s2.sls_sales)
    FROM bronze.crm_sales_details s2
    WHERE s2.sls_prd_key = s.sls_prd_key
);


--Q13. Year-wise Sales + Overall Average
    EXTRACT(YEAR FROM TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS sales_year,
    SUM(sls_sales) AS total_sales,
    (SELECT AVG(sls_sales) FROM bronze.crm_sales_details) AS overall_avg_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY sales_year
ORDER BY sales_year;

-- top 3 countries by sales
SELECT 
    l."CNTRY" AS country,
    SUM(s.sls_sales) AS total_sales
FROM bronze.crm_sales_details s
INNER JOIN bronze.crm_cust_info c 
    ON s.sls_cust_id = c.cst_id
INNER JOIN bronze.erp_loc_a101 l 
    ON REPLACE(l."CID", '-', '') = c.cst_key
GROUP BY l."CNTRY"
ORDER BY total_sales DESC
LIMIT 3;


-- Customers Who Placed More Orders than Average

SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    COUNT(s.sls_ord_num) AS total_orders
FROM bronze.crm_cust_info c
INNER JOIN bronze.crm_sales_details s 
    ON c.cst_id = s.sls_cust_id
GROUP BY c.cst_id, c.cst_firstname, c.cst_lastname
HAVING COUNT(s.sls_ord_num) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(sls_ord_num) AS order_count
        FROM bronze.crm_sales_details
        GROUP BY sls_cust_id
    ) t
)
ORDER BY total_orders DESC;



--Top 10 Customers by Sales (CTE)
WITH customer_sales AS (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT *
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 10;







--Product Sales with Order Count (CTE)
WITH product_sales AS (
    SELECT 
        sls_prd_key,
        SUM(sls_sales) AS total_sales,
        COUNT(*) AS total_orders
    FROM bronze.crm_sales_details
    GROUP BY sls_prd_key
)
SELECT *
FROM product_sales
ORDER BY total_sales DESC
LIMIT 10;




WITH product_sales AS (
    SELECT 
        sls_prd_key,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_prd_key
),
top_products AS (
    SELECT *
    FROM product_sales
    ORDER BY total_sales DESC
    LIMIT 5
)
SELECT * FROM top_products;



--Top 10 Customers with Names (CTE + JOIN)
WITH customer_sales AS (
    SELECT 
        sls_cust_id,
        SUM(sls_sales) AS total_sales
    FROM bronze.crm_sales_details
    GROUP BY sls_cust_id
)
SELECT 
    c.cst_id,
    c.cst_firstname,
    c.cst_lastname,
    cs.total_sales
FROM bronze.crm_cust_info c
INNER JOIN customer_sales cs 
    ON c.cst_id = cs.sls_cust_id
ORDER BY cs.total_sales DESC
LIMIT 10;