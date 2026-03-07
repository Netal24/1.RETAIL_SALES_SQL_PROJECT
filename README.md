# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `Retail_Sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_1;
USE sql_project_1;

create table Retail_Sales(
transactions_id	INT,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(10),
age	INT,
category VARCHAR(20),
quantity int,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.


**Display the first 5 rows from the Retail_Sales table.**
SELECT * FROM Retail_Sales
LIMIT 5;

**Find the total number of records in the Retail_Sales table.**
```sql
SELECT COUNT(*) FROM Retail_Sales;
```

**Find the number of non-NULL total_sale values in the table.**
```sql
SELECT COUNT(total_sale) FROM Retail_Sales;
```

**Find the total number of unique customers who made purchases.**
```sql
SELECT COUNT(DISTINCT customer_id) FROM Retail_Sales;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:


**1. Find all sales transactions that occurred on 5th November 2022**
```sql
SELECT *
FROM Retail_Sales
WHERE sale_date = '2022-11-05';
```

**2. Retrieve all Electronics sales transactions where the quantity sold is greater than 3 during December 2023**
```sql
SELECT *
FROM Retail_Sales
WHERE category = 'Electronics'
AND quantity > 3
AND DATE_FORMAT(sale_date, '%Y-%m') = '2023-12';
```

**3. Calculate the total quantity of Electronics products sold where more than 3 units were purchased per transaction in December 2022**
```sql
SELECT category,
       SUM(quantity) AS total_quantity
FROM Retail_Sales
WHERE category = 'Electronics'
AND quantity > 3
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-12'
GROUP BY category;
```

**4. Find the total sales revenue and total number of orders for each product category**
```sql
SELECT category,
       SUM(total_sale) AS net_sales,
       COUNT(*) AS total_orders
FROM Retail_Sales
GROUP BY category;
```

**5. Calculate the average age of customers purchasing products in each category**
```sql
SELECT category,
       ROUND(AVG(age),2) AS avg_age
FROM Retail_Sales
GROUP BY category;
```

**6. Find the average age of customers who purchased Beauty products**
```sql
SELECT ROUND(AVG(age),2) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty';
```

**7. Retrieve all transactions where the total sale amount exceeded 1100**
```sql
SELECT *
FROM Retail_Sales
WHERE total_sale > 1100;
```

**8. Determine the number of transactions made by each gender within each product category**
```sql
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM Retail_Sales
GROUP BY category, gender
ORDER BY category, gender DESC;
```

**9. Calculate the average monthly sales for each year and month, and sort the results by year and highest average sales**
```sql
SELECT 
      YEAR(sale_date) AS sale_year,
      MONTH(sale_date) AS sale_month,
      ROUND(AVG(total_sale),2) AS avg_sales
FROM Retail_Sales
GROUP BY sale_year, sale_month
ORDER BY sale_year ASC, avg_sales DESC;
```

**10. Identify the month with the highest average sales in each year**
```sql
SELECT *
FROM(
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale),2) AS avg_sales,
        RANK() OVER(
            PARTITION BY YEAR(sale_date)
            ORDER BY ROUND(AVG(total_sale),2) DESC
        ) AS rnk
    FROM Retail_Sales
    GROUP BY sale_year, sale_month
) t
WHERE rnk = 1;
```

**11. Find the top 5 customers who generated the highest total sales revenue**
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

**12. Calculate the number of unique customers who purchased products in each category**
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM Retail_Sales
GROUP BY category;
```

**13. Analyze the number of orders placed during different time shifts (Morning, Afternoon, Evening) using CTE**
```sql
WITH sales_shift
AS
(
SELECT *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM Retail_Sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM sales_shift
GROUP BY shift;
```

**14. Analyze the number of orders placed during different time shifts using Subquery**
```sql
SELECT
    shift,
    COUNT(*) AS total_orders
FROM
(
SELECT *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM Retail_Sales
) t
GROUP BY shift;
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

