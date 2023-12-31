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

GRANT ALL PRIVILEGES ON TABLE users TO makv;
GRANT ALL PRIVILEGES ON TABLE admins TO makv;
GRANT ALL PRIVILEGES ON TABLE students TO makv;
GRANT ALL PRIVILEGES ON TABLE books TO makv;
GRANT ALL PRIVILEGES ON TABLE transactions TO makv;
GRANT ALL PRIVILEGES ON TABLE fines TO makv;
GRANT ALL PRIVILEGES ON TABLE borrowing TO makv;
GRANT ALL PRIVILEGES ON TABLE edition TO makv;
GRANT ALL PRIVILEGES ON TABLE resources TO makv;
GRANT ALL PRIVILEGES ON TABLE prequels TO makv;
GRANT ALL PRIVILEGES ON TABLE author TO makv;
GRANT ALL PRIVILEGES ON TABLE language TO makv;
GRANT ALL PRIVILEGES ON TABLE genre TO makv;

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
Natural LEFT JOIN (
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
ORDER BY week;

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

--- check
SELECT *
FROM author
LEFT JOIN books ON author.bookid = books.bookid
LEFT JOIN resources ON books.bookid = resources.bookid
LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid

SELECT *
FROM author
LEFT JOIN books ON author.bookid = books.bookid
LEFT JOIN resources ON books.bookid = resources.bookid
LEFT JOIN (SELECT *
           FROM borrowing
           WHERE dor IS NOT NULL) AS borrowing ON resources.physicalid = borrowing.physicalid;

------------- Lab 3 ---------------

CREATE TABLE Books
(bookID integer PRIMARY KEY,
title varchar(100) NOT NULL,
pages integer NOT NULL CONSTRAINT positivePages CHECK (pages > 0)
);

CREATE TABLE Resources
(physicalID integer PRIMARY KEY,
bookID integer NOT NULL,
damaged BOOLEAN DEFAULT false,
CONSTRAINT FK_ResourceBookID FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE Prequels
(bookID INTEGER,
prequelID INTEGER,
PRIMARY KEY (bookID,prequelID),
CONSTRAINT FK_PrequelBookID FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE Edition
(bookID INTEGER,
ISBN varchar(20) NOT NULL,
edition Integer CONSTRAINT positiveEdition CHECK (edition > 0),
publisher varchar(100),
DoP Date,
PRIMARY KEY (bookID),
CONSTRAINT FK_EditionBookID FOREIGN KEY (bookID) REFERENCES Books(bookID));

CREATE TABLE Author
(bookID integer,
author varchar(100),
PRIMARY KEY (bookID, author),
CONSTRAINT FK_AuthorBookID FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE Genre
(bookID integer,
genre varchar(100),
PRIMARY KEY (bookID, genre),
CONSTRAINT FK_GenreBookID FOREIGN KEY (bookID) REFERENCES Books(bookID));

CREATE TABLE Language
(bookID INTEGER,
language varchar(100),
PRIMARY KEY (bookID, language),
CONSTRAINT FK_LanguageBookID FOREIGN KEY (bookID) REFERENCES Books(bookID));

CREATE TABLE Users
(userID integer PRIMARY KEY,
name varchar(100) NOT NULL,
address varchar(100) NOT NULL,
email varchar(50) NOT NULL,
CONSTRAINT validEmail CHECK (email LIKE '%@kth.se')
);

CREATE TABLE Students
(userID integer,
program varchar(100) NOT NULL,
PRIMARY KEY (userID),
CONSTRAINT FK_StudentUserID FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Admins
(userID integer,
department varchar(100) NOT NULL,
phoneNumber varchar(15) NOT NULL,
PRIMARY KEY (userID),
CONSTRAINT FK_AdminUserID FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Borrowing
(borrowingID Integer PRIMARY KEY,
physicalID integer NOT NULL,
userID integer NOT NULL,
DoB DATE DEFAULT CURRENT_DATE,
DoR DATE CONSTRAINT DoRNotBeforeDoB CHECK (DoR >= DoB),
DoE DATE DEFAULT CURRENT_DATE+7,
CONSTRAINT FK_BorrowingPhysicalID FOREIGN KEY (physicalID) REFERENCES Resources(physicalID),
CONSTRAINT FK_BorrowingUserID FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TYPE pMethod AS ENUM ('Klarna', 'Swish', 'Card','Cash');

CREATE TABLE Fines
(borrowingID integer,
Amount integer NOT NULL,
CONSTRAINT positiveAmount CHECK (Amount > 0),
PRIMARY KEY (borrowingID),
CONSTRAINT FK_FineBorrowingID FOREIGN KEY (borrowingID) REFERENCES Borrowing(borrowingID));
 
CREATE TABLE TRANSACTIONS
(transactionID integer PRIMARY KEY,
 borrowingID integer NOT NULL,
 paymentMethod pMethod NOT NULL,
 DoP DATE NOT NULL,
 CONSTRAINT FK_TransactionBorrowingID FOREIGN KEY (borrowingID) REFERENCES Borrowing(borrowingID)
 );
 
-- drop table admins,author,books,borrowing,edition,fines,genre,language,prequels,resources,students,transactions,users; 


-- 2) MONDIAL DATABASE 


-- 2.1) 

SELECT country.name, COUNT(*) AS num_neighbors
FROM country
JOIN borders ON country.code = borders.country1 OR country.code = borders.country2
GROUP BY country.code
ORDER BY num_neighbors


------- solution 2 (Only minimum) -------
WITH neighbors AS (
    SELECT country.name, COUNT(*) AS num_neighbors
    FROM country
    JOIN borders ON country.code = borders.country1 OR country.code = borders.country2
    GROUP BY country.code
)
SELECT *
FROM neighbors
WHERE num_neighbors = (SELECT MIN(num_neighbors) FROM neighbors);


-- 2.2) Write a query for all the languages in the database, that states number of speakers and sorts them from most spoken to least spoken.

SELECT
    spoken.language,
    COALESCE(ROUND(SUM((spoken.percentage / 100) * country.population), 0), 0) AS num_speakers -- COALESCE to handle NULL values
FROM
    country
LEFT JOIN
    spoken ON spoken.country = country.code
GROUP BY
    spoken.language
ORDER BY
    num_speakers DESC;


-- 2.3) Which bordering countries have the greatest contrast in wealth? We define wealth as GDP.
-- Tip: Remember to check the difference in wealth in both directions so that you don’t end up with just half the results. E.g. Germany and Switzerland but also Switzerland and Germany.

SELECT
    borders.country1,
    e1.gdp AS GDP1,
    borders.country2,
    e2.gdp AS GDP2,
    CASE
        WHEN e1.gdp / e2.gdp > 1 THEN ROUND(e1.gdp / e2.gdp, 0 )
        ELSE ROUND(e1.gdp / e2.gdp, 2)
    END AS ratio
FROM
    borders
LEFT JOIN
    economy AS e1 ON e1.country = country1
LEFT JOIN
    economy AS e2 ON e2.country = country2

    UNION

SELECT
    borders.country2 AS country1,
    e1.gdp AS GDP1,
    borders.country1 AS country2,
    e2.gdp AS GDP2,
    CASE
        WHEN e1.gdp / e2.gdp > 1 THEN ROUND(e1.gdp / e2.gdp, 0 )
        ELSE ROUND(e1.gdp / e2.gdp, 2)
    END AS ratio
FROM
    borders
LEFT JOIN
    economy AS e2 ON e2.country = country1
LEFT JOIN
    economy AS e1 ON e1.country = country2

ORDER BY ratio DESC NULLS LAST;


----- Check one way working
SELECT
    borders.country1,
    e1.gdp AS GDP1,
    borders.country2,
    e2.gdp AS GDP2,
    CASE
        WHEN e1.gdp > e2.gdp THEN ROUND(e1.gdp / e2.gdp, 0)
        WHEN e2.gdp > e1.gdp THEN ROUND(e2.gdp / e1.gdp, 0)
    END AS ratio
FROM
    borders
LEFT JOIN
    economy AS e1 ON e1.country = country1
LEFT JOIN
    economy AS e2 ON e2.country = country2
ORDER BY ratio DESC NULLS LAST;


---------- P+ ----------

----1)
WITH RECURSIVE reachable AS (
    SELECT
        CASE
            WHEN country1 = 'S' THEN country1
            WHEN country2 = 'S' THEN country2
        END AS country,
        CASE
            WHEN country1 = 'S' THEN country2
            WHEN country2 = 'S' THEN country1
        END AS next_country,
        1 AS num_crossings
    FROM borders
    WHERE country1 = 'S' OR country2 = 'S'

    UNION ALL

    SELECT
        CASE
            WHEN r.next_country = b.country1 THEN b.country1
            WHEN r.next_country = b.country2 THEN b.country2
        END AS country,
        CASE
            WHEN r.next_country = b.country1 THEN b.country2
            WHEN r.next_country = b.country2 THEN b.country1
        END AS country2,
        r.num_crossings + 1
    FROM
        borders b
    INNER JOIN
        reachable r ON
            ((r.next_country = b.country1 AND b.country2 != r.country) OR
            (r.next_country = b.country2 AND b.country1 != r.country))
            AND country not in (SELECT next_country FROM reachable)
    WHERE
        r.num_crossings < 5
)
SELECT next_country as code, name, MIN(num_crossings) AS min_crossings
FROM reachable
LEFT JOIN country ON country.code = next_country
GROUP BY next_country, name
ORDER BY min_crossings;


------- Possible solution 2 -------
WITH RECURSIVE initial_reachable AS (
    SELECT
        CASE
            WHEN country1 = 'S' THEN country1
            WHEN country2 = 'S' THEN country2
        END AS country,
        CASE
            WHEN country1 = 'S' THEN country2
            WHEN country2 = 'S' THEN country1
        END AS next_country,
        1 AS num_crossings
    FROM borders
    WHERE country1 = 'S' OR country2 = 'S'
),

filtered_reachable AS (
    SELECT
        ir.country,
        ir.next_country,
        ir.num_crossings
    FROM initial_reachable ir

    UNION ALL

    SELECT
        CASE
            WHEN fr.next_country = b.country1 THEN b.country1
            WHEN fr.next_country = b.country2 THEN b.country2
        END AS country,
        CASE
            WHEN fr.next_country = b.country1 THEN b.country2
            WHEN fr.next_country = b.country2 THEN b.country1
        END AS next_country,
        fr.num_crossings + 1
    FROM
        borders b
    INNER JOIN
        filtered_reachable fr ON
            (fr.next_country = b.country1 AND b.country2 != fr.country) OR
            (fr.next_country = b.country2 AND b.country1 != fr.country)
    WHERE
        fr.num_crossings < 5
)

SELECT next_country as code, name, MIN(num_crossings) AS min_crossings
FROM filtered_reachable
LEFT JOIN country ON country.code = filtered_reachable.next_country
WHERE next_country NOT IN (SELECT country FROM initial_reachable)
GROUP BY next_country, name
ORDER BY min_crossings;


-- P+ 2 

WITH RECURSIVE river_branches AS (
    SELECT
        name,
        name AS main_river,
        name AS branch,
        name ::text AS path,
        length,
        1 AS num_rivers
    FROM river
    WHERE name IN ('Nile', 'Amazonas', 'Yangtze', 'Rhein', 'Donau', 'Mississippi')

    UNION ALL

    SELECT
        r.name,
        rb.main_river,
        r.river,
        rb.path || ' -> ' || r.name,
        r.length + rb.length,
        rb.num_rivers + 1
    FROM
        river r
    INNER JOIN
        river_branches rb ON rb.name = r.river
),
max_num_rivers AS (
    SELECT
        main_river,
        MAX(num_rivers) AS max_num_rivers
    FROM
        river_branches
    GROUP BY
        main_river
)
SELECT
    RANK() OVER (ORDER BY mnr.max_num_rivers) AS rank,
    rb.path,
    rb.num_rivers,
    length
FROM
    river_branches rb
INNER JOIN
    max_num_rivers mnr ON rb.main_river = mnr.main_river AND rb.num_rivers = mnr.max_num_rivers
ORDER BY
    rank, length desc;



GRANT ALL PRIVILEGES ON TABLE airport TO hollstra;
GRANT ALL PRIVILEGES ON TABLE borders TO hollstra;
GRANT ALL PRIVILEGES ON TABLE city TO hollstra;
GRANT ALL PRIVILEGES ON TABLE citylocalname TO hollstra;
GRANT ALL PRIVILEGES ON TABLE cityothername TO hollstra;
GRANT ALL PRIVILEGES ON TABLE citypops TO hollstra;
GRANT ALL PRIVILEGES ON TABLE continent TO hollstra;
GRANT ALL PRIVILEGES ON TABLE country TO hollstra;
GRANT ALL PRIVILEGES ON TABLE countrylocalname TO hollstra;
GRANT ALL PRIVILEGES ON TABLE countryothername TO hollstra;
GRANT ALL PRIVILEGES ON TABLE countrypops TO hollstra;
GRANT ALL PRIVILEGES ON TABLE desert TO hollstra;
GRANT ALL PRIVILEGES ON TABLE economy TO hollstra;
GRANT ALL PRIVILEGES ON TABLE econompasses TO hollstra;
GRANT ALL PRIVILEGES ON TABLE ethnicgroup TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_estuary TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_island TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_lake TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_mountain TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_river TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_sea TO hollstra;
GRANT ALL PRIVILEGES ON TABLE geo_source TO hollstra;
GRANT ALL PRIVILEGES ON TABLE island TO hollstra;
GRANT ALL PRIVILEGES ON TABLE islandin TO hollstra;
GRANT ALL PRIVILEGES ON TABLE ismember TO hollstra;
GRANT ALL PRIVILEGES ON TABLE lake TO hollstra;
GRANT ALL PRIVILEGES ON TABLE lakeonisland TO hollstra;
GRANT ALL PRIVILEGES ON TABLE language TO hollstra;
GRANT ALL PRIVILEGES ON TABLE located TO hollstra;
GRANT ALL PRIVILEGES ON TABLE locatedon TO hollstra;
GRANT ALL PRIVILEGES ON TABLE mergeswith TO hollstra;
GRANT ALL PRIVILEGES ON TABLE mountain TO hollstra;
GRANT ALL PRIVILEGES ON TABLE mountainonisland TO hollstra;
GRANT ALL PRIVILEGES ON TABLE organization TO hollstra;
GRANT ALL PRIVILEGES ON TABLE politics TO hollstra;
GRANT ALL PRIVILEGES ON TABLE population TO hollstra;
GRANT ALL PRIVILEGES ON TABLE province TO hollstra;
GRANT ALL PRIVILEGES ON TABLE provincelocalname TO hollstra;
GRANT ALL PRIVILEGES ON TABLE provinceothername TO hollstra;
GRANT ALL PRIVILEGES ON TABLE provpops TO hollstra;
GRANT ALL PRIVILEGES ON TABLE religion TO hollstra;
GRANT ALL PRIVILEGES ON TABLE river TO hollstra;
GRANT ALL PRIVILEGES ON TABLE riveronisland TO hollstra;
GRANT ALL PRIVILEGES ON TABLE riverthrough TO hollstra;
GRANT ALL PRIVILEGES ON TABLE sea TO hollstra;
GRANT ALL PRIVILEGES ON TABLE spoken TO hollstra;




------- Homework 3 ----------

CREATE TABLE Items (
    itemID integer PRIMARY KEY,
    name varchar(100) NOT NULL,
    value integer NOT NULL,
    CONSTRAINT positivePrice CHECK (price > 0)
);

CREATE TABLE People (
    personID integer PRIMARY KEY,
    name varchar(100) NOT NULL,
);

CREATE TABLE Ownership (
    personID integer NOT NULL,
    itemID integer NOT NULL,
    CONSTRAINT PK_Ownership PRIMARY KEY (personID, itemID),
    CONSTRAINT FK_OwnershipPersonID FOREIGN KEY (personID) REFERENCES People(personID),
    CONSTRAINT FK_OwnershipItemID FOREIGN KEY (itemID) REFERENCES Items(itemID)
);

INSERT INTO Items (itemID, name, value) VALUES (1, 'item1', 10);
INSERT INTO Items (itemID, name, value) VALUES (2, 'item2', 20);
INSERT INTO Items (itemID, name, value) VALUES (3, 'item3', 30);
INSERT INTO Items (itemID, name, value) VALUES (4, 'item4', 40);
INSERT INTO Items (itemID, name, value) VALUES (5, 'item5', 50);
INSERT INTO Items (itemID, name, value) VALUES (6, 'item6', 5);
INSERT INTO Items (itemID, name, value) VALUES (7, 'item7', 15);
INSERT INTO Items (itemID, name, value) VALUES (8, 'item8', 25);
INSERT INTO Items (itemID, name, value) VALUES (9, 'item9', 35);
INSERT INTO Items (itemID, name, value) VALUES (10, 'item10', 45);

INSERT INTO People (personID, name) VALUES (1, 'person1');
INSERT INTO People (personID, name) VALUES (2, 'person2');
INSERT INTO People (personID, name) VALUES (3, 'person3');

INSERT INTO Ownership (personID, itemID) VALUES (1, 1);
INSERT INTO Ownership (personID, itemID) VALUES (1, 2);
INSERT INTO Ownership (personID, itemID) VALUES (1, 3);

INSERT INTO Ownership (personID, itemID) VALUES (2, 4);
INSERT INTO Ownership (personID, itemID) VALUES (2, 5);
INSERT INTO Ownership (personID, itemID) VALUES (2, 6);
INSERT INTO Ownership (personID, itemID) VALUES (2, 7);

INSERT INTO Ownership (personID, itemID) VALUES (3, 8);
INSERT INTO Ownership (personID, itemID) VALUES (3, 9);
INSERT INTO Ownership (personID, itemID) VALUES (3, 4);

GRANT ALL PRIVILEGES ON TABLE items TO makv;
GRANT ALL PRIVILEGES ON TABLE people TO makv;
GRANT ALL PRIVILEGES ON TABLE ownership TO makv;





------------- Lab 4 ---------------

-- 1) Write a query that shows all titles and how many copies of each title that are available for borrowing.
SELECT title, COUNT(*) AS num_copies
FROM books
LEFT JOIN resources ON books.bookid = resources.bookid
NATURAL JOIN borrowing
GROUP BY title
ORDER BY title;

-- 2) Write a query that shows all titles and how many copies of each title that are available for borrowing.
WITH all_copies AS (
    SELECT title, COUNT(*) AS num_copies
    FROM books
    LEFT JOIN resources ON books.bookid = resources.bookid
    GROUP BY title
), 
borrowed_copies AS (
    SELECT title, COUNT(*) AS num_copies_borrowed
    FROM books
    LEFT JOIN resources ON books.bookid = resources.bookid
    LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid
    WHERE borrowing.dor IS NULL
    GROUP BY title
)
SELECT books.title, books.bookid, SUM(all_copies.num_copies - borrowed_copies.num_copies_borrowed) AS num_copies_available
FROM books
LEFT JOIN all_copies ON books.title = all_copies.title
LEFT JOIN borrowed_copies ON books.title = borrowed_copies.title
GROUP BY books.title, books.bookid
ORDER BY title;


SELECT resources.physicalid FROM resources LEFT JOIN books on resources.bookid = books.bookid WHERE books.title = '{title}' AND resources.physicalid NOT IN (SELECT resources.physicalid FROM resources LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid WHERE borrowing.dor IS NULL);

-- Check if a user has a fine that is not paid
SELECT * FROM fines WHERE borrowingid IN (SELECT borrowingid FROM borrowing WHERE userid = {user_id}) AND borrowingid NOT IN (SELECT borrowingid FROM transactions);




---------- P+ ----------
-- Elf Table
CREATE TABLE Elf (
    Name VARCHAR(255) PRIMARY KEY,
    Favourite_Candy VARCHAR(255)
);

-- Gift Table
CREATE TABLE Gift (
    Elf_Name VARCHAR(255),
    Wrappingpaper_type VARCHAR(255),
    Wrappingpaper_Length INTEGER,
    Content_Cost INTEGER,
    PRIMARY KEY (Elf_Name, Wrappingpaper_type),
    FOREIGN KEY (Elf_Name) REFERENCES Elf(Name),
    FOREIGN KEY (Wrappingpaper_type) REFERENCES Wrappingpaper(Wrappingpaper_Type)
);

-- Wrappingpaper Table
CREATE TABLE Wrappingpaper (
    Wrappingpaper_Type VARCHAR(255) PRIMARY KEY,
    Cost_Per_Meter INTEGER
);


--- Views

CREATE VIEW ViewA AS
SELECT Elf_Name, Wrappingpaper_Length * Cost_Per_Meter + Content_Cost AS cost_per_gift
FROM Gift
NATURAL JOIN Wrappingpaper;

CREATE VIEW ViewB AS
SELECT Elf_Name, SUM(cost_per_gift) AS total_cost
FROM ViewA
GROUP BY Elf_Name;

CREATE VIEW ViewC AS
SELECT Favourite_Candy, AVG(total_cost) AS average
FROM ViewB
JOIN Elf ON Elf_Name = name
GROUP BY Favourite_Candy;