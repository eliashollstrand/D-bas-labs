------------ Create tables ------------

CREATE TABLE Books 
(
    isbn char(13) NOT NULL PRIMARY KEY,
    title varchar(255) NOT NULL,
    edition int, 
    language varchar(255), 
    date_of_publication date, 
    publisher varchar(255), 
    author varchar(255), 
    genre varchar(255), 
    prequel varchar(255)
);
 
CREATE TABLE Copies 
(
    physical_id int NOT NULL PRIMARY KEY,
    isbn char(13),
    damage boolean,
    CONSTRAINT FK_CopyISBN FOREIGN KEY (isbn) REFERENCES Books(isbn)
);

 
CREATE TABLE Users 
(
    user_id int NOT NULL PRIMARY KEY, 
    email varchar(255) NOT NULL, 
    full_name varchar(255) NOT NULL, 
    address varchar(255) NOT NULL      
);
 
CREATE TABLE Students 
(
    user_id int NOT NULL PRIMARY KEY,
    program varchar(255) NOT NULL,
    CONSTRAINT FK_StudentUserID  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
 
CREATE TABLE Admins
(
    user_id int NOT NULL PRIMARY KEY,
    phone_number varchar(255) NOT NULL,
    department varchar(255) NOT NULL,
    CONSTRAINT FK_AdminUserID FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Loans 
(
    borrowing_id int NOT NULL PRIMARY KEY, 
    physical_id int, 
    user_id int,
    date_of_borrowing date, 
    due_date date, 
    date_of_return date,
    CONSTRAINT FK_LoanPhysicalID FOREIGN KEY (physical_id) REFERENCES Copies(physical_id),
    CONSTRAINT FK_LoanUserID FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
 
CREATE TABLE Fines
(
    borrowing_id int PRIMARY KEY, 
    amount int NOT NULL, 
    CONSTRAINT FK_FineBorrowingID FOREIGN KEY (borrowing_id) REFERENCES Loans(borrowing_id)
);
 
CREATE TABLE Transactions 
(
    transaction_id int NOT NULL PRIMARY KEY, 
    borrowing_id int,
    amount int NOT NULL, 
    date_of_payment date NOT NULL, 
    payment_method varchar(255) NOT NULL,
    CONSTRAINT FK_TransactionBorrowingID FOREIGN KEY (borrowing_id) REFERENCES Fines(borrowing_id)
);

GRANT ALL PRIVILEGES ON TABLE users TO hollstra;
GRANT ALL PRIVILEGES ON TABLE admins TO hollstra;
GRANT ALL PRIVILEGES ON TABLE students TO hollstra;
GRANT ALL PRIVILEGES ON TABLE books TO hollstra;
GRANT ALL PRIVILEGES ON TABLE copies TO hollstra;
GRANT ALL PRIVILEGES ON TABLE transactions TO hollstra;
GRANT ALL PRIVILEGES ON TABLE fines TO hollstra;
GRANT ALL PRIVILEGES ON TABLE loans TO hollstra;

------------ Insertions ------------

-- Insert students

INSERT INTO Users (user_id, email, full_name, address) VALUES (1, 'email1@kth.se', 'student1', 'address1');
INSERT INTO Students (user_id, program) VALUES (1, 'program1');

INSERT INTO Users (user_id, email, full_name, address) VALUES (2, 'email2@kth.se', 'student2', 'address2');
INSERT INTO Students (user_id, program) VALUES (2, 'program2');

INSERT INTO Users (user_id, email, full_name, address) VALUES (3, 'email3@kth.se', 'student3', 'address3');
INSERT INTO Students (user_id, program) VALUES (3, 'program3');

INSERT INTO Users (user_id, email, full_name, address) VALUES (4, 'email4@kth.se', 'student4', 'address4');
INSERT INTO Students (user_id, program) VALUES (4, 'program4');

INSERT INTO Users (user_id, email, full_name, address) VALUES (5, 'email5@kth.se', 'student5', 'address5');
INSERT INTO Students (user_id, program) VALUES (5, 'program5');

-- Insert admins

INSERT INTO Users (user_id, email, full_name, address) VALUES (6, 'email6@kth.se', 'admin6', 'address6');
INSERT INTO Admins (user_id, phone_number, department) VALUES (6, 'phone_number6', 'department6');

-- Insert Books

INSERT INTO Books (isbn, title, language, date_of_publication, publisher, author, genre) VALUES ('9780552160896', 'Angels And Demons', 'Engelska', '2009-08-28', 'Transworld Publishers Ltd', 'Dan Brown', 'Thriller');
INSERT INTO Books (isbn, title, language, date_of_publication, publisher, author, genre, prequel) VALUES ('9780552159715', 'The Da Vinci Code', 'Engelska', '2009-08-28', 'Transworld Publishers Ltd', 'Dan Brown', 'Thriller', 'Angels And Demons');
INSERT INTO Books (isbn, title, language, date_of_publication, publisher, author, genre, prequel) VALUES ('9780552149525', 'The Lost Symbol', 'Engelska', '2010-07-22', 'Transworld Publishers Ltd', 'Dan Brown', 'Thriller', 'Angels And Demons, The Da Vinci Code');
INSERT INTO Books (isbn, title, edition, language, date_of_publication, publisher, author, genre) VALUES ('9789129723946', 'Harry Potter och de vises sten', '8', 'Svenska', '2015-10-01', 'Rabén & Sjögren', 'J.K. Rowling', 'Fantasy');
INSERT INTO Books (isbn, title, edition, language, date_of_publication, publisher, author, genre, prequel) VALUES ('9789129701364', 'Harry Potter och Hemligheternas kammare', '2', 'Svenska', '2016-10-06', 'Rabén & Sjögren', 'J.K. Rowling', 'Fantasy', 'Harry Potter och de vises sten');

-- Insert Copies

INSERT INTO Copies (physical_id, isbn, damage) VALUES (1, '9780552160896', True); /* Angels And Demons */
INSERT INTO Copies (physical_id, isbn, damage) VALUES (2, '9780552160896', False); /* Angels And Demons*/
INSERT INTO Copies (physical_id, isbn, damage) VALUES (3, '9780552159715', True); /* The Da Vinci Code*/
INSERT INTO Copies (physical_id, isbn, damage) VALUES (4, '9780552159715', True); /*The Da Vinci Code*/
INSERT INTO Copies (physical_id, isbn, damage) VALUES (5, '9780552159715', False); /*The Da Vinci Code*/
INSERT INTO Copies (physical_id, isbn, damage) VALUES (6, '9780552149525', False); /*The Lost Symbol*/
INSERT INTO Copies (physical_id, isbn, damage) VALUES (7, '9789129723946', True); /*Harry Potter och de vises sten*/

-- Insert Loans

INSERT INTO Loans (borrowing_id, physical_id, user_id, date_of_borrowing, due_date, date_of_return) VALUES (1, 1, 1, '2023-10-01', '2023-10-08', '2023-10-07'); /*Angels And Demons*/
INSERT INTO Loans (borrowing_id, physical_id, user_id, date_of_borrowing, due_date, date_of_return) VALUES (2, 3, 2, '2023-10-03', '2023-10-10', '2023-10-07'); /*Angels And Demons*/
INSERT INTO Loans (borrowing_id, physical_id, user_id, date_of_borrowing, due_date) VALUES (3, 5, 3, '2023-10-05', '2023-10-12'); /*The Da Vinci Code*/
INSERT INTO Loans (borrowing_id, physical_id, user_id, date_of_borrowing, due_date) VALUES (4, 7, 4, '2023-10-06', '2023-10-13'); /*The Da Vinci Code*/
INSERT INTO Loans (borrowing_id, physical_id, user_id, date_of_borrowing, due_date) VALUES (5, 1, 5, '2023-10-09', '2023-10-16'); /*Angels And Demons*/

-- Insert fines

INSERT INTO Fines (borrowing_id, amount) VALUES (4, 100);

------------ Queries ------------

SELECT full_name AS name FROM Users;

SELECT * FROM Loans; -- or SELECT physical_id FROM Loans; depending on what is wanted 

SELECT title FROM Books;

SELECT * FROM Fines;


------------ P+ ------------

CREATE TABLE Patient 
(
    id int NOT NULL PRIMARY KEY,
    diagnosises varchar(255) NOT NULL,
    name varchar(255) NOT NULL,
    age int NOT NULL
);

CREATE TABLE Department 
(
    department_name varchar(255) NOT NULL PRIMARY KEY,
    buildingNr int NOT NULL
);

CREATE TABLE Employee
(
    id int NOT NULL PRIMARY KEY,
    name varchar(255) NOT NULL,
    phone_number varchar(255) NOT NULL,
    mentor_id int,
    start_date date NOT NULL,
    department_name varchar(255) NOT NULL,
    CONSTRAINT FK_EmployeeMentorID FOREIGN KEY (mentor_id) REFERENCES Employee(id),
    CONSTRAINT FK_EmployeeDepartmentName FOREIGN KEY (department_name) REFERENCES Department(department_name)
);

CREATE TABLE Doctor
(
    id int NOT NULL PRIMARY KEY,
    specialization varchar(255) NOT NULL,
    roomNr int NOT NULL,
    CONSTRAINT FK_DoctorID FOREIGN KEY (id) REFERENCES Employee(id)
);

CREATE TABLE Nurse 
(
    id int NOT NULL PRIMARY KEY,
    degree varchar(255) NOT NULL,
    CONSTRAINT FK_NurseID FOREIGN KEY (id) REFERENCES Employee(id)
);

CREATE TABLE Treating
(
    doctor_id int NOT NULL,
    patient_id int NOT NULL,
    CONSTRAINT PK_Treating PRIMARY KEY (doctor_id, patient_id),
    CONSTRAINT FK_TreatingDoctorID FOREIGN KEY (doctor_id) REFERENCES Doctor(id),
    CONSTRAINT FK_TreatingPatientID FOREIGN KEY (patient_id) REFERENCES Patient(id)
);

GRANT ALL PRIVILEGES ON TABLE patient TO hollstra;
GRANT ALL PRIVILEGES ON TABLE department TO hollstra;
GRANT ALL PRIVILEGES ON TABLE employee TO hollstra;
GRANT ALL PRIVILEGES ON TABLE doctor TO hollstra;
GRANT ALL PRIVILEGES ON TABLE nurse TO hollstra;
GRANT ALL PRIVILEGES ON TABLE treating TO hollstra;


INSERT INTO Department (department_name, buildingNr) VALUES ('department1', 1);
INSERT INTO Employee (id, name, phone_number, start_date, department_name) VALUES (1, 'employee1', 'phone_number1','2020-01-01', 'department1');
INSERT INTO Employee (id, name, phone_number, mentor_id, start_date, department_name) VALUES (2, 'employee2', 'phone_number2', 1, '2020-01-01', 'department1');

----- DROP TABLES -----
DROP TABLE users CASCADE;
DROP TABLE admins CASCADE;
DROP TABLE students CASCADE;
DROP TABLE books CASCADE;
DROP TABLE copies CASCADE;
DROP TABLE transactions CASCADE;
DROP TABLE fines CASCADE;
DROP TABLE loans CASCADE;


DROP TABLE patient CASCADE;
DROP TABLE department CASCADE;
DROP TABLE employee CASCADE;
DROP TABLE doctor CASCADE;
DROP TABLE nurse CASCADE;
DROP TABLE treating CASCADE;


------------------- Lab 2 -------------------

GRANT ALL PRIVILEGES ON TABLE users TO hollstra;
GRANT ALL PRIVILEGES ON TABLE admins TO hollstra;
GRANT ALL PRIVILEGES ON TABLE students TO hollstra;
GRANT ALL PRIVILEGES ON TABLE books TO hollstra;
GRANT ALL PRIVILEGES ON TABLE transactions TO hollstra;
GRANT ALL PRIVILEGES ON TABLE fines TO hollstra;
GRANT ALL PRIVILEGES ON TABLE borrowing TO hollstra;
GRANT ALL PRIVILEGES ON TABLE edition TO hollstra;
GRANT ALL PRIVILEGES ON TABLE resources TO hollstra;
GRANT ALL PRIVILEGES ON TABLE prequels TO hollstra;
GRANT ALL PRIVILEGES ON TABLE author TO hollstra;
GRANT ALL PRIVILEGES ON TABLE language TO hollstra;
GRANT ALL PRIVILEGES ON TABLE genre TO hollstra;

-- 1)
SELECT title, string_agg(genre.genre, ',' )
FROM books, genre
WHERE books.bookid = genre.bookid
GROUP BY title
ORDER BY title
COLLATE "C";

-- 2)
SELECT title, rank
FROM (
    SELECT title,RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM books, genre, borrowing, resources
    WHERE books.bookid = genre.bookid
      AND genre.genre = 'RomCom'
      AND borrowing.physicalid = resources.physicalid
      AND resources.bookid = books.bookid
    GROUP BY title
    ORDER BY rank
) AS top5
WHERE rank <= 5

-- 3)
SELECT week, borrowed, returned, late
FROM (
    SELECT week, COUNT(*) AS borrowed
    FROM (
        SELECT DATE_PART('week', dob) AS week
        FROM borrowing
    ) AS weeks
    GROUP BY week
) AS borrowed
NATURAL JOIN(
    SELECT week, COUNT(*) AS returned
    FROM (
        SELECT DATE_PART('week', dor) AS week
        FROM borrowing
        WHERE dor IS NOT NULL
    ) AS weeks
    GROUP BY week
) AS returned
NATURAL JOIN (
    SELECT week, COUNT(*) AS late
    FROM (
        SELECT DATE_PART('week', dor) AS week
        FROM borrowing
        WHERE dor IS NOT NULL
            and dor > doe
    ) AS weeks
    GROUP BY week
) AS late
WHERE week <= 30
ORDER BY week

-- 4)
SELECT title, every(prequelid IS NOT NULL) AS every, dob
FROM borrowing
NATURAL JOIN resources
NATURAL JOIN books
LEFT JOIN prequels ON books.bookid = prequels.bookid
WHERE DATE_PART('month', dob) = 2
GROUP BY title, dob
ORDER BY title
COLLATE "C";

-- 5)
-- Uses the first book in the series as input, and finds all sequels to that book recursively
-- then joins the book table to get the title of the books.
-- Creates a new column for the bookid of the prequel book, and fills it with NULL for the first book in the series
WITH RECURSIVE prequel_TABLE AS (
    SELECT bookid, NULL::integer AS prequelid
    FROM books
    WHERE bookid = 76418 -- The first book in the series
    UNION ALL
    SELECT p.bookid, p.prequelid
    FROM prequels p
    INNER JOIN prequel_TABLE t ON t.bookid = p.prequelid
)
SELECT books.title, prequel_TABLE.bookid, prequel_TABLE.prequelid
FROM prequel_TABLE
NATURAL JOIN books;

-- 6)
SELECT author, bool_or(date_part('month', dor) = 5 AND dor IS NOT NULL) AS returned_in_may
FROM author
LEFT JOIN books ON author.bookid = books.bookid
LEFT JOIN resources ON books.bookid = resources.bookid
LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid
GROUP BY author
ORDER BY returned_in_may DESC, author

SELECT author, bool_or(date_part('month', dor) = 5 AND dor IS NOT NULL) AS returned_in_may
FROM author
NATURAL JOIN books
NATURAL JOIN resources
NATURAL JOIN borrowing 
GROUP BY author
ORDER BY returned_in_may DESC

-- not working
SELECT author,
CASE WHEN date_part('month', dor) = 5 AND dor IS NOT NULL THEN 't' ELSE 'f' END AS returned_in_may
FROM author
left JOIN books
NATURAL JOIN resources
NATURAL JOIN borrowing
GROUP BY author
ORDER BY returned_in_may DESC


--- check
SELECT *
FROM author
LEFT JOIN books ON author.bookid = books.bookid
LEFT JOIN resources ON books.bookid = resources.bookid
LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid

SELECT author,
CASE WHEN date_part('month', dor) = 5 AND dor IS NOT NULL THEN 't' ELSE 'f' END AS returned_in_may
FROM author
NATURAL JOIN resources
NATURAL JOIN borrowing
GROUP BY author
ORDER BY returned_in_may DESC

SELECT *
FROM author
LEFT JOIN books ON author.bookid = books.bookid
LEFT JOIN resources ON books.bookid = resources.bookid
LEFT JOIN (SELECT *
           FROM borrowing
           WHERE dor IS NOT NULL) AS borrowing ON resources.physicalid = borrowing.physicalid;