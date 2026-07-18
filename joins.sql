select * from bronze.crm_cust_info;
select * from bronze.crm_sales_details;

select * cst_firstname,
         cst_lastname,


-- Sales aur Customer info ko join karke top 10 sales orders mein customer ka naam aur gender dikhao.

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


