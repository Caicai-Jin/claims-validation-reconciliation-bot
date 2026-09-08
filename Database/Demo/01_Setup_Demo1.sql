-- Creates an isolated demo database. Does not modify ClaimsAutomation.
-- Refuses to reuse an existing demo database or overwrite its results.
USE master;
SET NOCOUNT ON;

IF DB_ID(N'ClaimsAutomation') IS NULL
    THROW 50001, 'The source database ClaimsAutomation does not exist.', 1;

IF DB_ID(N'ClaimsAutomationDemo1') IS NOT NULL
    THROW 50002, 'ClaimsAutomationDemo1 already exists. Use a fresh demo name throughout this script, or use the verification scripts for the existing demo.', 1;

EXEC(N'CREATE DATABASE ClaimsAutomationDemo1;');

-- Dynamic SQL runs after the new database exists.
EXEC(N'
USE ClaimsAutomationDemo1;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

SELECT * INTO dbo.Members FROM ClaimsAutomation.dbo.Members;
SELECT * INTO dbo.Providers FROM ClaimsAutomation.dbo.Providers;
SELECT * INTO dbo.CoverageLimits FROM ClaimsAutomation.dbo.CoverageLimits;

SELECT TOP (0) * INTO dbo.ProcessedClaims
FROM ClaimsAutomation.dbo.ProcessedClaims;

ALTER TABLE dbo.ProcessedClaims
ADD CONSTRAINT PK_DemoProcessedClaims PRIMARY KEY (ClaimID);

ALTER TABLE dbo.ProcessedClaims
ADD CONSTRAINT DF_DemoProcessedAt DEFAULT SYSUTCDATETIME() FOR ProcessedAt;

-- A direct SELECT INTO preserves the source RunID identity column.
SELECT TOP (0) * INTO dbo.RunHistory
FROM ClaimsAutomation.dbo.RunHistory;

ALTER TABLE dbo.RunHistory
ADD CONSTRAINT PK_DemoRunHistory PRIMARY KEY (RunID);

COMMIT TRANSACTION;
SELECT DB_NAME() AS DemoDatabase,
       (SELECT COUNT(*) FROM dbo.Members) AS Members,
       (SELECT COUNT(*) FROM dbo.Providers) AS Providers,
       (SELECT COUNT(*) FROM dbo.CoverageLimits) AS CoverageLimits,
       (SELECT COUNT(*) FROM dbo.ProcessedClaims) AS SavedClaims;
');

-- Expected: Members 4, Providers 3, CoverageLimits 3, SavedClaims 0.
-- Next: configure the demo queue and Config.xlsx as described in the demo guide.
