-- SQL RETAIL SALES ANALYSTS -- P10 

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(		
					transactions_id INT PRIMARY KEY,	
					sale_date DATE,
					sale_time TIME,
					customer_id	INT,
					gender	VARCHAR (15),
					age	INT,
					category VARCHAR (15),
					quantiy	INT,
					price_per_unit	FLOAT,
					cogs	FLOAT,
					total_sale FLOAT
			)
;

INSERT INTO retail_sales
SELECT *
FROM `sql - retail sales analysis_utf`;


-- CREATE DUPLICATE --

CREATE TABLE retail_sales_dup
LIKE retail_sales;

INSERT INTO retail_sales_dup
SELECT *
FROM retail_sales;

SELECT *
FROM retail_sales_dup;

SELECT COUNT(*)
FROM retail_sales_dup;


-- DATA CLEANING

SELECT *
FROM retail_sales_dup
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
	total_sale IS NULL
;

-- DELETE NULL DATA --

DELETE
FROM retail_sales_dup
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
	total_sale IS NULL
;


-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE 

SELECT COUNT(*) AS TOTAL_SALES
FROM retail_sales_dup;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE ?

SELECT 
	COUNT(DISTINCT customer_id) AS CUSTOMERS
FROM 
	retail_sales_dup;

-- categories we have?

SELECT 
	COUNT(DISTINCT category) AS CUSTOMERS
FROM 
	retail_sales_dup;


SELECT DISTINCT category AS CUSTOMERS
FROM retail_sales_dup;

-- Data Analyst & Business Key Problem & Answer

-- Q1. WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05' --

SELECT *
FROM 
	retail_sales_dup
WHERE 
	sale_date = '2022-11-05';

-- Q.2 WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTION WHERE THE CATEGORY IS  'CLOTHING' AND THE QUANTITY SOLD IS 4 OR MORE IN THE MONTH OF NOV-2022

SELECT *
FROM retail_sales_dup
WHERE 
	category = 'clothing'
AND 
	quantiy >= 4
AND 
	sale_date LIKE '2022-11%'
;


-- Q3 WRITE A SQL QUERY TO CALCULATE THE TOTAL_SALE FOR EACH CATEGORY

SELECT 
	category, 
	SUM(total_sale) as net_sale,
    COUNT(*)
FROM retail_sales_dup
GROUP BY category;

-- Q4 WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY' CATEGORY.

SELECT 
	ROUND(AVG(age),2) AS AVG_AGE
FROM 
	retail_sales_dup
WHERE 
	category = 'beauty';


-- Q5 WRITE A SQL QUERY TO FIND ALL TRANSACTION WHERE THE TOTAL SALES IS GREATER THAN 1000.alter

SELECT *
FROM 
	retail_sales_dup
WHERE 
	total_sale > 1000;


-- Q6 WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTION (TRANSACTION_ID) MADE BY EACH GENDER IN EACH CATEGORY
SELECT 
	category, 
	gender, 
	COUNT(transactions_id)
FROM retail_sales_dup
GROUP BY 
	category,
	gender
ORDER BY 1;


-- Q7 WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH. FIND OUT BEST SELLING MONTH TO EACH YEAR

SELECT *
FROM retail_sales_dup;


WITH t1 AS
(
SELECT 
	SUBSTRING(sale_date, 1,4) AS `YEAR`,
    SUBSTRING(sale_date, 6,2) AS `MONTH`, 
	ROUND(AVG(total_sale),2) AS avg_sales,
    RANK () OVER(PARTITION BY SUBSTRING(sale_date, 1,4) ORDER BY AVG(total_sale) DESC) AS ranking 
FROM 
	retail_sales_dup
GROUP BY 
	`YEAR`,`MONTH`
ORDER BY 
	`YEAR`, avg_sales DESC
)
SELECT *
FROM 
	t1
WHERE 
	ranking = 1 ;



-- Q8  WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE BIGGEST TOTAL SALES

SELECT *
FROM retail_sales_dup;


SELECT 
	customer_id, 
	SUM(total_sale) AS total_sale,
	RANK () OVER (ORDER BY SUM(total_sale) DESC) AS ranking
FROM 
	retail_sales_dup
GROUP BY 
	customer_id
LIMIT 5
;


-- Q9 WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY

SELECT *
FROM retail_sales_dup;

SELECT 
	category,
    COUNT(DISTINCT customer_id) AS unique_customer
FROM
	retail_sales_dup
GROUP BY 
	category;
    
    
    
-- Q10 WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EXAMPLE MORNING <= 12, AFTERNOON BETWEEN 12 & 17, EVENING >17)

SELECT *
FROM retail_sales_dup;


WITH hourly_sale
AS (
SELECT *,
CASE
	WHEN SUBSTRING(sale_time,1,2) < 12 THEN 'Morning'
    WHEN SUBSTRING(sale_time,1,2) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END as shift
FROM retail_sales_dup
)
SELECT 
	shift, COUNT(*)
FROM 
	hourly_sale
GROUP BY 
	shift
;



-- Q11 WRITE A SQL QUERY STATING THE BEST SELLING CATEGORY BY YEAR USING TOTAL_SALE

SELECT 
	SUBSTRING(sale_date, 1,4) `YEAR`, 
    SUM(total_sale) SALES
FROM 
	retail_sales_dup
GROUP BY 
	`YEAR`
ORDER BY 
	SALES DESC ;

-- Q12 WRITE A SQL QUERY SHOWING top 5 CUSTOMER THAT SPENT MOST MONEY PER CATEGORY


WITH best_cus AS (
SELECT 
	category,
	customer_id, 
	SUM(total_sale) AS BESTCUS_PRICE,
    RANK () OVER(PARTITION BY category ORDER BY SUM(total_sale) DESC) AS Ranking
FROM 
	retail_sales_dup
GROUP BY 
	category, 
    customer_id
)
SELECT *
FROM best_cus
WHERE Ranking <= 5
;

-- Q.13 WRITE A SQL QUERY THAT STATE THE TOP 5 OVERALL BEST CUSTOMER

SELECT 
	customer_id, 
	SUM(total_sale) AS SALES,
    RANK () OVER (ORDER BY SUM(total_sale) DESC) AS Ranking
FROM 
	retail_sales_dup
GROUP BY 
	customer_id
LIMIT 5;