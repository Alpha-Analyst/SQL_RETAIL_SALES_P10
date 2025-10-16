# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `SQL_PROJECT_P10`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p10`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p10;

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
```

### 2. Data Exploration & Cleaning

- **Create Duplicate**: Duplicate the data set 
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.



### i. Create Duplicate

```sql
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
```


### ii. Data Cleaning

```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05**:
```sql
SELECT *
FROM 
	retail_sales_dup
WHERE 
	sale_date = '2022-11-05';
```

2. **WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTION WHERE THE CATEGORY IS  'CLOTHING' AND THE QUANTITY SOLD IS 4 OR MORE IN THE MONTH OF NOV-2022**:
```sql
SELECT *
FROM retail_sales_dup
WHERE 
	category = 'clothing'
AND 
	quantiy >= 4
AND 
	sale_date LIKE '2022-11%'
;
```

3. **WRITE A SQL QUERY TO CALCULATE THE TOTAL_SALE FOR EACH CATEGORY**:
```sql
SELECT 
	category, 
	SUM(total_sale) as net_sale,
    COUNT(*)
FROM retail_sales_dup
GROUP BY category;
```

4. **WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY' CATEGORY.**:
```sql
SELECT 
	ROUND(AVG(age),2) AS AVG_AGE
FROM 
	retail_sales_dup
WHERE 
	category = 'beauty';
```

5. **WRITE A SQL QUERY TO FIND ALL TRANSACTION WHERE THE TOTAL SALES IS GREATER THAN 1000.**:
```sql
SELECT *
FROM 
	retail_sales_dup
WHERE 
	total_sale > 1000;
```

6. **WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTION (TRANSACTION_ID) MADE BY EACH GENDER IN EACH CATEGORY**:
```sql
SELECT 
	category, 
	gender, 
	COUNT(transactions_id)
FROM retail_sales_dup
GROUP BY 
	category,
	gender
ORDER BY 1;
```

7. **WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH. FIND OUT BEST SELLING MONTH TO EACH YEAR**:
```sql
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
```

8. **WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE BIGGEST TOTAL SALES**:
```sql
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
```

9. **WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY**:
```sql
SELECT 
	category,
    COUNT(DISTINCT customer_id) AS unique_customer
FROM
	retail_sales_dup
GROUP BY 
	category;
```

10. **WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EXAMPLE MORNING <= 12, AFTERNOON BETWEEN 12 & 17, EVENING >17)**:
```sql
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
```

11. **WRITE A SQL QUERY STATING THE BEST SELLING CATEGORY BY YEAR USING TOTAL_SALE**
```sql
SELECT 
	SUBSTRING(sale_date, 1,4) `YEAR`, 
    SUM(total_sale) SALES
FROM 
	retail_sales_dup
GROUP BY 
	`YEAR`
ORDER BY 
	SALES DESC ;
```
12. **WRITE A SQL QUERY SHOWING top 5 CUSTOMER THAT SPENT MOST MONEY PER CATEGORY**
```sql
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
```
13. **WRITE A SQL QUERY THAT STATE THE TOP 5 OVERALL BEST CUSTOMER**
```sql
SELECT 
	customer_id, 
	SUM(total_sale) AS SALES,
    RANK () OVER (ORDER BY SUM(total_sale) DESC) AS Ranking
FROM 
	retail_sales_dup
GROUP BY 
	customer_id
LIMIT 5;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Alpha-Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **MAIL**: adebowaledamilaredebo@gmail.com
- **ALL_SOCIALS**: Alpha-Analyst


Thank you for your support, and I look forward to connecting with you!
