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
GO
