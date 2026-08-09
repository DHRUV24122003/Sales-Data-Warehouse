--Find Names with Extra Spaces
SELECT 
    cst_id,
    cst_firstname,
    cst_lastname,
    LENGTH(cst_firstname) AS original_length,
    LENGTH(TRIM(cst_firstname)) AS trimmed_length
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname)
LIMIT 20;


--Clean Customer Names
SELECT 
    cst_id,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    TRIM(cst_firstname) || ' ' || TRIM(cst_lastname) AS full_name
FROM bronze.crm_cust_info;



--Check Gender Distribution
SELECT 
    cst_gndr,
    COUNT(*) AS total
FROM bronze.crm_cust_info
GROUP BY cst_gndr
ORDER BY total DESC;


--Standardize Gender Values
SELECT 
    cst_id,
    cst_firstname,
    cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr
FROM bronze.crm_cust_info
LIMIT 20;






//