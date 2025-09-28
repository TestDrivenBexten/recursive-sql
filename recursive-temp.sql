-- Use the Genealogy database
USE [Genealogy];
GO

-- Create temporary table to store ancestor hierarchy
CREATE TABLE #AncestorTemp (
    PersonID INT,
    FirstName NVARCHAR(50),
    ParentID INT,
    RootPersonID INT,
    RootPersonName NVARCHAR(50),
    Level INT
);

-- Create index on PersonID for better performance
CREATE CLUSTERED INDEX IX_AncestorTemp_PersonID ON #AncestorTemp (PersonID);

-- Insert root ancestors (persons with no parent)
INSERT INTO #AncestorTemp (PersonID, FirstName, ParentID, RootPersonID, RootPersonName, Level)
SELECT PersonID, FirstName, ParentID, PersonID, FirstName, 0
FROM Person
WHERE ParentID IS NULL;

-- Recursive processing using WHILE loop
DECLARE @RowsAdded INT = 1;
WHILE @RowsAdded > 0
BEGIN
    INSERT INTO #AncestorTemp (PersonID, FirstName, ParentID, RootPersonID, RootPersonName, Level)
    SELECT 
        p.PersonID,
        p.FirstName,
        p.ParentID,
        a.RootPersonID,
        a.RootPersonName,
        a.Level + 1
    FROM Person p
    INNER JOIN #AncestorTemp a ON p.ParentID = a.PersonID
    WHERE p.PersonID NOT IN (SELECT PersonID FROM #AncestorTemp);
    
    SET @RowsAdded = @@ROWCOUNT;
END

-- Select results
SELECT 
    PersonID,
    FirstName,
    RootPersonID,
    RootPersonName AS TopParent,
    Level AS GenerationLevel
FROM #AncestorTemp
ORDER BY RootPersonID, Level, PersonID;

-- Clean up
DROP TABLE #AncestorTemp;
