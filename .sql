-- 1. Create Tables

CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    genre VARCHAR(50),
    total_copies INT,
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    membership_date DATE
);

CREATE TABLE Issued_Books (
    issue_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 2. Insert Sample Authors

INSERT INTO Authors VALUES (1, 'J.K. Rowling', 'UK');
INSERT INTO Authors VALUES (2, 'George Orwell', 'UK');
INSERT INTO Authors VALUES (3, 'Jane Austen', 'UK');
INSERT INTO Authors VALUES (4, 'Mark Twain', 'USA');

-- 3. Insert Sample Books

INSERT INTO Books VALUES (101, 'Harry Potter and the Sorcerer''s Stone', 1, 'Fantasy', 10, 10);
INSERT INTO Books VALUES (102, '1984', 2, 'Dystopian', 5, 5);
INSERT INTO Books VALUES (103, 'Pride and Prejudice', 3, 'Romance', 8, 8);
INSERT INTO Books VALUES (104, 'Adventures of Huckleberry Finn', 4, 'Adventure', 6, 6);

-- 4. Insert Sample Members

INSERT INTO Members VALUES (201, 'Alice Johnson', 'alice@gmail.com', '1234567890', '2023-01-15');
INSERT INTO Members VALUES (202, 'Bob Smith', 'bob@gmail.com', '0987654321', '2023-02-10');
INSERT INTO Members VALUES (203, 'Charlie Brown', 'charlie@gmail.com', '1122334455', '2023-03-05');

-- 5. Issue Books

INSERT INTO Issued_Books VALUES (301, 101, 201, '2025-06-10', '2025-06-20', NULL);
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 101;

INSERT INTO Issued_Books VALUES (302, 102, 202, '2025-06-15', '2025-06-25', NULL);
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 102;

-- 6. Return a Book

UPDATE Issued_Books SET return_date = '2025-06-18' WHERE issue_id = 301;
UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = 101;

-- 7. Query: List All Books

SELECT * FROM Books;

-- 8. Query: Available Books

SELECT book_id, title, available_copies 
FROM Books 
WHERE available_copies > 0;

-- 9. Query: Currently Issued Books

SELECT 
    i.issue_id,
    b.title,
    m.name AS member_name,
    i.issue_date,
    i.due_date
FROM Issued_Books i
JOIN Books b ON i.book_id = b.book_id
JOIN Members m ON i.member_id = m.member_id
WHERE i.return_date IS NULL;

-- 10. Query: Overdue Books

SELECT 
    i.issue_id,
    b.title,
    m.name AS member_name,
    i.due_date
FROM Issued_Books i
JOIN Books b ON i.book_id = b.book_id
JOIN Members m ON i.member_id = m.member_id
WHERE i.return_date IS NULL AND i.due_date < CURRENT_DATE;

-- 11. Query: Members and Number of Books Borrowed

SELECT 
    m.name,
    COUNT(i.issue_id) AS books_borrowed
FROM Members m
LEFT JOIN Issued_Books i ON m.member_id = i.member_id
GROUP BY m.name;

-- 12. Query: Book Borrow History

SELECT 
    b.title,
    m.name AS borrowed_by,
    i.issue_date,
    i.return_date
FROM Issued_Books i
JOIN Books b ON i.book_id = b.book_id
JOIN Members m ON i.member_id = m.member_id
ORDER BY i.issue_date DESC;

-- 13. Add New Member

INSERT INTO Members VALUES (204, 'Diana Prince', 'diana@gmail.com', '5566778899', '2025-06-20');

-- 14. Add New Book

INSERT INTO Books VALUES (105, 'Emma', 3, 'Romance', 4, 4);

-- 15. Book Search by Title or Author

SELECT 
    b.book_id,
    b.title,
    a.name AS author_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
WHERE b.title LIKE '%Emma%' OR a.name LIKE '%Jane%';

