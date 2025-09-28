-- Create Genealogy database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Genealogy')
BEGIN
    CREATE DATABASE [Genealogy];
    PRINT 'Genealogy database created successfully.';
END
ELSE
BEGIN
    PRINT 'Genealogy database already exists.';
END
GO

-- Use the Genealogy database
USE [Genealogy];
GO

-- Add any initial table structures or data here if needed
PRINT 'Switched to Genealogy database.';

-- Create Person table with self-referencing foreign key
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person]') AND type in (N'U'))
BEGIN
    CREATE TABLE Person (
        PersonID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        ParentID INT NULL,
        CONSTRAINT FK_Person_Parent FOREIGN KEY (ParentID) REFERENCES Person(PersonID)
    );
    PRINT 'Person table created successfully.';
END
ELSE
BEGIN
    PRINT 'Person table already exists.';
END
GO
