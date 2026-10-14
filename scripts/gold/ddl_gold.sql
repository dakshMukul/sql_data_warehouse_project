/*
======================================================
DDL Script: Create Gold Views
======================================================
Script Purpose:
	This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimention and fact tables (star schema)

    Each view performs transformation and combines data from silver layer to 
    produce a clean, enriched and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
======================================================
*/

-- ======================================================
-- Create dimension: gold.dim_customers
-- ======================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
Go

CREATE VIEW gold.dim_customers AS

SELECT ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key, 
	ci.cst_id AS customer_id, 
	ci.cst_key AS customer_number, 
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	ci.cst_marital_status AS marital_status,
		CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(cb.gen, 'n/a')
	END AS gender,
	cl.CNTRY AS country,
	cb.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS cb
ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.CID

GO

-- ======================================================
-- Create dimension: gold.dim_products
-- ======================================================


IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
Go

CREATE VIEW gold.dim_products AS 

SELECT ROW_NUMBER() OVER(ORDER BY p.prd_start_dt,p.prd_key) AS product_key,
	p.prd_id AS product_id,
	p.prd_key AS product_number,
	p.prd_nm AS product_name,
	p.prd_line product_line,
	p.cat_id AS category_id,
	c.CAT AS category,
	c.SUBCAT AS subcategory,
	c.MAINTENANCE AS maintainance,
	p.prd_cost AS cost,
	p.prd_start_dt AS start_date
FROM silver.crm_prd_info AS p
LEFT JOIN silver.erp_px_cat_g1v2 AS c
ON p.cat_id = c.ID
WHERE p.prd_end_dt IS NULL -- filter out all historical data
GO
-- ======================================================
-- Create dimension: gold.fact_sales
-- ======================================================


IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
Go

CREATE VIEW gold.fact_sales AS 
SELECT sls_ord_num AS order_number,
      p.product_key,
      c.customer_key,
      sls_order_dt AS order_date,
      sls_ship_dt AS ship_date,
      sls_due_dt AS due_date,
      sls_sales AS sales_amount,
      sls_quantity qty,
      sls_price AS price
FROM silver.crm_sales_details AS s
LEFT JOIN gold.dim_products AS p
ON s.sls_prd_key = p.product_number
LEFT JOIN gold.dim_customers AS c
ON s.sls_cust_id = c.customer_id
GO
