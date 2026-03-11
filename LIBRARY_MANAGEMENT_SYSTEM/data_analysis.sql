use library_management_db;
SELECT * FROM return_status;
-- Find all books issued in 2024.

SELECT * FROM branch;
SELECT issued_book_name,issued_date
FROM issued_status
WHERE YEAR(issued_date) = '2024';

-- Display the number of books issued each day.

SELECT issued_date,COUNT(*)
FROM issued_status
GROUP BY 1;

-- Find the latest issued book.

SELECT issued_book_name,issued_date
FROM issued_status
ORDER BY 1 ASC
LIMIT 1;

-- Show all books issued after 1st June 2023.

SELECT issued_book_name,issued_date
FROM issued_status
WHERE issued_date > '2024-04-01';


-- Find the number of books issued per month.

SELECT MONTHNAME(issued_date) AS Month,COUNT(*) AS Total_Books
FROM issued_status
GROUP BY 1;

-- Find which branch issued the most books in 2024.
SELECT b.branch_id,b.branch_address,COUNT(i.issued_id) AS Total_issued
FROM branch b JOIN employees e
ON b.branch_id = e.branch_id
JOIN issued_status i
ON e.emp_id = i.issued_emp_id
GROUP BY 1,2;

-- Find average reading time of members.

SELECT i.issued_book_name,ROUND(AVG(r.return_date - i.issued_date),0) AS avg_duration
FROM issued_status i
JOIN return_status r
ON i.issued_id = r.issued_id
GROUP BY 1;

-- Find members who returned books after more than 30 days.

SELECT i.issued_book_name,ROUND(SUM(r.return_date - i.issued_date),0) AS duration
FROM issued_status i
JOIN return_status r
ON i.issued_id = r.issued_id
GROUP BY 1
HAVING duration > 200;

SELECT 
YEAR(reg_date) AS year,
MONTHNAME(reg_date) AS month,
COUNT(member_id) AS new_members
FROM members
GROUP BY 1,2
ORDER BY 1,2;

SELECT * FROM employees;
SELECT * FROM branch;

-- List Employees with Their Branch Manager's Name and their branch details
SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees e1
JOIN branch b
ON e1.branch_id = b.branch_id    
JOIN
employees e2
ON e2.emp_id = b.manager_id;

-- Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

-- 

DELIMITER //
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

CALL add_returns_records('R101','IS101');