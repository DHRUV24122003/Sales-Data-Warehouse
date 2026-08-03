select * from bronze.crm_cust_info
select * from bronze.crm_sales_details
select * from bronze.crm_prd_info
select * from bronze.erp_loc_a101

-- Q1. Average sales se zyada wali sales records dikhao.
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



--subquery in select statement
select cst_firstname,
cst_lastname
from bronze.crm_cust_info
where cst_id  not in (select distinct sls_cust_id from bronze.crm_sales_details where sls_cust_id is not null)



SELECT 
    cst_id,
    cst_firstname,
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_id NOT IN (
    SELECT DISTINCT sls_cust_id
    FROM bronze.crm_sales_details
    WHERE sls_cust_id IS NOT NULL
);

-- Q4. Average se kam price wale products ki list dikhao (crm_prd_info se).

select * from bronze.crm_prd_info
where prd_cost <(select avg(prd_cost) from bronze.crm_prd_info where prd_cost is not null)


--Q5. Sabse mehnga product ka naam aur cost dikhao.

select prd_id,prd_nm,prd_cost
from bronze.crm_prd_info
where prd_cost =(select max(prd_cost) from bronze.crm_prd_info where prd_cost is not null) 


--Q6. Un customers ki details dikhao jinki total sales 10000 se zyada hai (IN + subquery).

select * from bronze.crm_cust_info
where cst_id in (select sls_cust_id from bronze.crm_sales_details group by sls_cust_id having sum(sls_sales) > 10000)



--Q7. Har product ki total sales nikaalo aur sirf unhe dikhao jinki sales average product sales se zyada hai.

SELECT 
    sls_prd_key,
    SUM(sls_sales) AS total_sales
FROM bronze.crm_sales_details



--Q7. Har product ki total sales nikaalo aur sirf unhe dikhao jinki sales average product sales se zyada hai.
select sls_prd_key,
sum(sls_sales) as total_sales
from bronze.crm_sales_details
group by sls_prd_key
having sum(sls_sales) > (select avg(product_total) from (select sum(sls_sales) as product_total from bronze.crm_sales_details group by sls_prd_key) ) order by total_sales desc limit 10

---Q8. Sabse zyada orders dene wale top 5 customers ke naam dikhao.

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


--Q9. Un products ko dikhao jo kabhi sell nahi hue (NOT IN).

select * from bronze.crm_prd_info
WHERE SUBSTRING(prd_key FROM 7) NOT IN (select distinct sls_prd_key from bronze.crm_sales_details where sls_prd_key is not null)


--.10 Customer table se un customers ko dikhao jinka cst_id sales table mein exist karta hai (EXISTS use karke).

select * from bronze.crm_cust_info c
where exists( select sls_cust_id from bronze.crm_sales_details s where s.sls_cust_id = c.cst_id)


-- 11 Har customer ki total sales ke saath unka rank nikaalo (subquery se – Window function mat use karna).
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


--12  Un orders ko dikhao jinki sales usi product ki average sales se zyada hai (Correlated Subquery)

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


--Q13. Har year ki total sales nikaalo aur uske saath overall average sales bhi dikhao (subquery se).
SELECT 
    EXTRACT(YEAR FROM TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')) AS sales_year,
    SUM(sls_sales) AS total_sales,
    (SELECT AVG(sls_sales) FROM bronze.crm_sales_details) AS overall_avg_sales
FROM bronze.crm_sales_details
WHERE LENGTH(sls_order_dt::TEXT) = 8
GROUP BY sales_year
ORDER BY sales_year;

--q14 top 3 countries by sales
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


--q 15Un customers ko dikhao jinhone average se zyada orders kiye hain.

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