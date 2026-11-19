-- PROJECT 2: LIBRARY MANAGEMENT DATABASE

CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- 1. Authors Table
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(100) NOT NULL
);

-- 2. Books Table
CREATE TABLE IF NOT EXISTS Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(100) NOT NULL,
    author_id INT,
    category VARCHAR(50),
    isbn VARCHAR(30) UNIQUE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- 3. Members Table
CREATE TABLE IF NOT EXISTS Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- 4. Loans Table
CREATE TABLE IF NOT EXISTS Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 5. Insert Authors
INSERT IGNORE INTO Authors (author_id, author_name)
VALUES
(1, 'R.K. Narayan'),
(2, 'Chetan Bhagat'),
(3, 'James Clear'),
(4, 'Robert Kiyosaki');

-- 6. Insert Books
INSERT IGNORE INTO Books
(book_id, book_name, author_id, category, isbn)
VALUES
(1, 'Malgudi Days', 1, 'Fiction', 'ISBN001'),
(2, 'Five Point Someone', 2, 'Novel', 'ISBN002'),
(3, 'Atomic Habits', 3, 'Self Help', 'ISBN003'),
(4, 'Rich Dad Poor Dad', 4, 'Finance', 'ISBN004');

-- 7. Insert Members
INSERT IGNORE INTO Members
(member_id, member_name, email, phone)
VALUES
(1, 'Anjali', 'anjali@gmail.com', '9876543210'),
(2, 'Rahul', 'rahul@gmail.com', '9876543211'),
(3, 'Priya', 'priya@gmail.com', '9876543212'),
(4, 'Arun', 'arun@gmail.com', '9876543213');

-- 8. Insert Loan Records
INSERT INTO Loans
(loan_id, book_id, member_id, issue_date, due_date, return_date)
VALUES
(1, 1, 1, '2026-11-01', '2026-11-10', NULL),
(2, 2, 2, '2026-11-02', '2026-11-12', '2026-11-14'),
(3, 3, 3, '2026-11-15', '2026-11-25', NULL),
(4, 4, 4, '2026-11-05', '2026-11-15', NULL);

-- 9. Display All Books
SELECT * FROM Books;

-- 10. Display All Members
SELECT * FROM Members;

-- 11. Display Books with Authors
SELECT b.book_name, a.author_name, b.category
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

-- 12. Display Issued Books
SELECT * FROM Loans
WHERE return_date IS NULL;

-- 13. Display Returned Books
SELECT * FROM Loans
WHERE return_date IS NOT NULL;

-- 14. Display Member Loan Details
SELECT m.member_name, b.book_name,
       l.issue_date, l.due_date, l.return_date
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Books b ON l.book_id = b.book_id;

-- 15. Find Overdue Books
SELECT b.book_name, m.member_name, l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL
AND l.due_date < CURDATE();

-- 16. Calculate Late Return Fine
-- Fine = Rs. 5 per day
SELECT m.member_name, b.book_name,
       DATEDIFF(l.return_date, l.due_date) * 5 AS fine
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.return_date > l.due_date;

-- 17. Count Total Books
SELECT COUNT(*) AS total_books FROM Books;

-- 18. Count Total Members
SELECT COUNT(*) AS total_members FROM Members;

-- 19. Count Books by Category
SELECT category, COUNT(*) AS total_books
FROM Books
GROUP BY category;

-- 20. Find Most Borrowed Books
SELECT b.book_name, COUNT(l.loan_id) AS borrow_count
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.book_name
ORDER BY borrow_count DESC;

-- 21. Search Books by Category
SELECT * FROM Books
WHERE category = 'Fiction';

-- 22. Find Members Who Have Not Borrowed Books
SELECT * FROM Members
WHERE member_id NOT IN (
    SELECT member_id FROM Loans
);

-- 23. Display Currently Borrowed Books
SELECT b.book_name, m.member_name
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;

-- 24. Display All Loan Records
SELECT * FROM Loans;