-- Use the Genealogy database
USE [Genealogy];
GO

-- Recursive CTE to find the top parent (root ancestor) for each person
WITH AncestorCTE AS (
    -- Base case: Start with all persons
    SELECT 
        PersonID,
        FirstName,
        ParentID,
        PersonID AS RootPersonID,
        FirstName AS RootPersonName,
        0 AS Level
    FROM Person
    WHERE ParentID IS NULL -- Root ancestors
    
    UNION ALL
    
    -- Recursive case: Find children and assign them their root ancestor
    SELECT 
        p.PersonID,
        p.FirstName,
        p.ParentID,
        a.RootPersonID,
        a.RootPersonName,
        a.Level + 1
    FROM Person p
    INNER JOIN AncestorCTE a ON p.ParentID = a.PersonID
)
SELECT 
    PersonID,
    FirstName,
    RootPersonID,
    RootPersonName AS TopParent,
    Level AS GenerationLevel
FROM AncestorCTE
ORDER BY RootPersonID, Level, PersonID;
