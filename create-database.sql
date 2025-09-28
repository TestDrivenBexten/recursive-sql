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
        FirstName NVARCHAR(50) NOT NULL UNIQUE,
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

-- Insert genealogy data: Apsu -> Lahmu -> Anshar -> Ea -> Marduk
INSERT INTO Person (FirstName, ParentID) VALUES ('Apsu', NULL);
INSERT INTO Person (FirstName, ParentID) VALUES ('Lahmu', (SELECT PersonID FROM Person WHERE FirstName = 'Apsu'));
INSERT INTO Person (FirstName, ParentID) VALUES ('Anshar', (SELECT PersonID FROM Person WHERE FirstName = 'Lahmu'));
INSERT INTO Person (FirstName, ParentID) VALUES ('Ea', (SELECT PersonID FROM Person WHERE FirstName = 'Anshar'));
INSERT INTO Person (FirstName, ParentID) VALUES ('Marduk', (SELECT PersonID FROM Person WHERE FirstName = 'Ea'));

PRINT 'Genealogy data inserted successfully.';

-- Insert additional genealogy data: El -> Baal
INSERT INTO Person (FirstName, ParentID) VALUES ('El', NULL);
INSERT INTO Person (FirstName, ParentID) VALUES ('Baal', (SELECT PersonID FROM Person WHERE FirstName = 'El'));

PRINT 'Additional genealogy data inserted successfully.';
GO

-- Stored procedure to insert a genealogy of length n
CREATE PROCEDURE InsertGenealogy
    @Length INT,
    @RootName NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Counter INT = 1;
    DECLARE @CurrentParentID INT = NULL;
    DECLARE @CurrentName NVARCHAR(50);
    
    -- Generate root name if not provided
    IF @RootName IS NULL
        SET @RootName = 'Person_';
    
    -- Insert root person
    INSERT INTO Person (FirstName, ParentID) VALUES (@RootName, NULL);
    SET @CurrentParentID = SCOPE_IDENTITY();
    
    -- Insert descendants
    WHILE @Counter < @Length
    BEGIN
        SET @CurrentName = @RootName + '_Gen' + CAST(@Counter AS VARCHAR(10));
        
        INSERT INTO Person (FirstName, ParentID) VALUES (@CurrentName, @CurrentParentID);
        SET @CurrentParentID = SCOPE_IDENTITY();
        SET @Counter = @Counter + 1;
    END
    
    PRINT 'Genealogy of length ' + CAST(@Length AS VARCHAR(10)) + ' created starting with ' + @RootName;
END
GO
