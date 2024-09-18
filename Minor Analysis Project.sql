//**Minor Analysis Project**//
//**The goal of the project is to identify the number of students who have a minor and the corresponding colleges they belong to **//
//** Final data will be connect to power bi for visualizations**//

//**Preview data after importing**//
SELECT TOP (1000) [Studentid]
      ,[Firstname]
      ,[Lastname]
      ,[Program]
      ,[SingleMajor]
      ,[DoubleMajor]
      ,[TripleMajor]
      ,[SingleMinor]
      ,[DoubleMinor]
      ,[TripleMinor]
      ,[MajorStatus]
      ,[MinorStatus]
      ,[Colleges]
  FROM [School_project].[dbo].[Cleaned data 2024];

  //**Drop columns that are irrelevant to final analysis**//
ALTER TABLE [School_project].[dbo].[Cleaned data 2024]
DROP COLUMN SingleMajor, DoubleMajor;

ALTER TABLE [School_project].[dbo].[Cleaned data 2024]
DROP COLUMN TripleMajor;

ALTER TABLE [School_project].[dbo].[Cleaned data 2024]
DROP COLUMN MajorStatus,MinorStatus;

//** View table to confirm successful deletion of columns**//
SELECT *
FROM [School_project].[dbo].[Cleaned data 2024];

//**classifications of minors**//

CREATE OR ALTER VIEW minorclassification AS 

WITH CTE_minorclass AS (

SELECT 
    [Studentid],
    [Firstname],
    [Lastname],
    [Program],
    [SingleMinor],
    [DoubleMinor] ,
    [TripleMinor],
    [Colleges],
    CASE 
        WHEN SingleMinor NOT LIKE 'NULL' AND DoubleMinor  LIKE 'NULL' AND TripleMinor LIKE 'NULL' THEN 'Single Minor'
       WHEN SingleMinor NOT LIKE 'NULL' AND DoubleMinor NOT LIKE 'NULL' AND TripleMinor LIKE 'NULL' THEN 'Double Minor'
        WHEN SingleMinor NOT LIKE 'NULL' AND DoubleMinor NOT LIKE 'NULL' AND TripleMinor NOT LIKE 'NULL' THEN 'Triple Minor'
        ELSE 'No Minor'
    END AS MinorStatus
FROM 
    [School_project].[dbo].[Cleaned data 2024])

SELECT *
FROM CTE_minorclass;

SELECT *
FROM minorclassification;






