# Library Management System using SQL Project 

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_management_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.


## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](c:\Users\jajun\Pictures\Screenshots\Screenshot 2026-03-09 212825.png)

- **Database Creation**: Created a database named `library_management_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_management_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

1. **Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
2. **Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

3. **Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

4. **Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


5. **Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1
```

### 3. CTAS (Create Table As Select)

6. **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

7. **Task 7: Find all books issued in 2024.**:

```sql
SELECT * FROM branch;
SELECT issued_book_name,issued_date
FROM issued_status
WHERE YEAR(issued_date) = '2024';
```

8. **Task 8: Display the number of books issued each day.**:

```sql
SELECT issued_date,COUNT(*)
FROM issued_status
GROUP BY 1;
```

9. **Task 9: Find the latest issued book.**:
```sql
SELECT issued_book_name,issued_date
FROM issued_status
ORDER BY 1 ASC
LIMIT 1;
```

10. **Task 10:  Show all books issued after 1st June 2023.**:

```sql
SELECT issued_book_name,issued_date
FROM issued_status
WHERE issued_date > '2024-04-01';
```

11. **Task 11: Find which branch issued the most books in 2024.**:
```sql
SELECT b.branch_id,b.branch_address,COUNT(i.issued_id) AS Total_issued
FROM branch b JOIN employees e
ON b.branch_id = e.branch_id
JOIN issued_status i
ON e.emp_id = i.issued_emp_id
GROUP BY 1,2;
```

12. **Task 12: Find average reading time of members.***
```sql
SELECT i.issued_book_name,ROUND(AVG(r.return_date - i.issued_date),0) AS avg_duration
FROM issued_status i
JOIN return_status r
ON i.issued_id = r.issued_id
GROUP BY 1;
```

13. **Task 13: Find members who returned books after more than 30 days.**
```sql
SELECT i.issued_book_name,ROUND(SUM(r.return_date - i.issued_date),0) AS duration
FROM issued_status i
JOIN return_status r
ON i.issued_id = r.issued_id
GROUP BY 1
HAVING duration > 200;
```

14. **Task 14: Find the books whose total borrowing duration exceeds 200 days.**
```sql
SELECT i.issued_book_name,ROUND(SUM(r.return_date - i.issued_date),0) AS duration
FROM issued_status i
JOIN return_status r
ON i.issued_id = r.issued_id
GROUP BY 1
HAVING duration > 200;
```

15. **Task 15: Analyze monthly library membership growth.**
```sql
SELECT 
YEAR(reg_date) AS year,
MONTHNAME(reg_date) AS month,
COUNT(member_id) AS new_members
FROM members
GROUP BY 1,2
ORDER BY 1,2;
```

16. **Task 16: Display employee details along with their branch information and branch manager name.**
```sql
SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees e1
JOIN branch b
ON e1.branch_id = b.branch_id    
JOIN
employees e2
ON e2.emp_id = b.manager_id;
```

17. **Task 17: Find books that have been issued but not yet returned.**
```sql
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

18. **Task 18: Create a stored procedure to process book returns.**
```sql
DELIMITER //

CREATE PROCEDURE add_returns_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10)
)

BEGIN

DECLARE v_isbn VARCHAR(50);
DECLARE v_book_name VARCHAR(80);

-- Insert return record
INSERT INTO return_status(return_id, issued_id, return_date)
VALUES (p_return_id, p_issued_id, CURRENT_DATE());

-- Get book details
SELECT issued_book_isbn, issued_book_name
INTO v_isbn, v_book_name
FROM issued_status
WHERE issued_id = p_issued_id;

-- Update book availability
UPDATE books
SET status = 'yes'
WHERE isbn = v_isbn;

-- Show confirmation message
SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END //

DELIMITER ;
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


