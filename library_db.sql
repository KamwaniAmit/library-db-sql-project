Step 1: Create the Database & Tables

-- ================================================
--  Create Database
-- ================================================
CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

-- ================================================
--  TABLE: Authors
-- ================================================
CREATE TABLE Authors (
    AuthorID      INT IDENTITY(1,1) PRIMARY KEY,
    FirstName     NVARCHAR(50)     NOT NULL,
    LastName      NVARCHAR(50)     NOT NULL,
    BirthDate     DATE,
    Country        NVARCHAR(50)
);

-- ================================================
--  TABLE: Books
-- ================================================
CREATE TABLE Books (
    BookID        INT IDENTITY(1,1) PRIMARY KEY,
    Title         NVARCHAR(100)    NOT NULL,
    ISBN          VARCHAR(13)      NOT NULL UNIQUE,
    PublishedYear INT              NOT NULL,
    AuthorID      INT              NOT NULL,
    
    CONSTRAINT FK_Books_Authors 
        FOREIGN KEY (AuthorID) 
        REFERENCES Authors(AuthorID)
        ON DELETE CASCADE      -- If an author is deleted, delete their books
);

-- ================================================
--  TABLE: Members
-- ================================================
CREATE TABLE Members (
    MemberID      INT IDENTITY(1,1) PRIMARY KEY,
    FirstName     NVARCHAR(50)     NOT NULL,
    LastName      NVARCHAR(50)     NOT NULL,
    Email         VARCHAR(100)     NOT NULL UNIQUE,
    JoinDate      DATE DEFAULT GETDATE()
);

-- ================================================
--  TABLE: Loans
-- ================================================
CREATE TABLE Loans (
    LoanID        INT IDENTITY(1,1) PRIMARY KEY,
    BookID        INT              NOT NULL,
    MemberID      INT              NOT NULL,
    LoanDate      DATE NOT NULL    DEFAULT GETDATE(),
    DueDate       DATE NOT NULL,
    ReturnDate    DATE,
    
    CONSTRAINT FK_Loans_Books   
        FOREIGN KEY (BookID)   
        REFERENCES Books(BookID)
        ON DELETE CASCADE,
        
    CONSTRAINT FK_Loans_Members 
        FOREIGN KEY (MemberID) 
        REFERENCES Members(MemberID)
        ON DELETE CASCADE
);
GO

Step 2: Insert Sample Data

-- AUTHORS
INSERT INTO Authors (FirstName, LastName, BirthDate, Country) VALUES
('Jane',   'Austen',   '1775-12-16', 'United Kingdom'),
('George', 'Orwell',   '1903-06-25', 'India'),
('J.K.',   'Rowling',  '1965-07-31', 'United Kingdom'),
('Agatha', 'Christie', '1890-09-15', 'United Kingdom');

-- BOOKS
INSERT INTO Books (Title, ISBN, PublishedYear, AuthorID) VALUES
('Pride and Prejudice',      '9780141439518', 1813, 1),
('1984',                    '9780451524935', 1949, 2),
('Harry Potter & the Philosopher’s Stone', '9780747532743', 1997, 3),
('Murder on the Orient Express', '9780007527473', 1934, 4),
('Animal Farm',             '9780451526342', 1945, 2);

-- MEMBERS
INSERT INTO Members (FirstName, LastName, Email, JoinDate) VALUES
('Alice',  'Johnson',  'alice.j@example.com', '2023-01-10'),
('Bob',    'Smith',    'bob.smith@email.com', '2022-11-22'),
('Clara',  'Davis',    'clara.davis@outlook.com', '2024-03-05'),
('David',  'Wilson',   'david.wilson@mail.com', '2023-07-30');

-- LOANS  (DueDate = LoanDate + 14 days)
INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate) VALUES
(1, 1, '2024-05-01', DATEADD(DAY, 14, '2024-05-01')),   -- Alice borrowed Pride & Prejudice
(2, 2, '2024-05-03', DATEADD(DAY, 14, '2024-05-03')),   -- Bob borrowed 1984
(3, 3, '2024-05-10', DATEADD(DAY, 14, '2024-05-10')),   -- Clara borrowed Harry Potter
(4, 4, '2024-05-12', DATEADD(DAY, 14, '2024-05-12'));   -- David borrowed Murder on Orient Express

-- Mark a book as RETURNED (Alice returned her book on 2024-05-15)
UPDATE Loans SET ReturnDate = '2024-05-15' WHERE LoanID = 1;
GO
