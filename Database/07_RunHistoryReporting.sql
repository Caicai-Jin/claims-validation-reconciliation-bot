-- Run once in the database configured for the bot. Safe to run again.
IF OBJECT_ID('dbo.RunHistory','U') IS NULL
 CREATE TABLE dbo.RunHistory (RunID int IDENTITY PRIMARY KEY, StartTime datetime2 NOT NULL, EndTime datetime2 NULL, TotalClaims int NOT NULL DEFAULT 0, Approved int NOT NULL DEFAULT 0, Rejected int NOT NULL DEFAULT 0, Failed int NOT NULL DEFAULT 0);
IF COL_LENGTH('dbo.RunHistory','RunKey') IS NULL ALTER TABLE dbo.RunHistory ADD RunKey nvarchar(36) NULL;
IF COL_LENGTH('dbo.RunHistory','Skipped') IS NULL ALTER TABLE dbo.RunHistory ADD Skipped int NOT NULL DEFAULT 0;
IF COL_LENGTH('dbo.RunHistory','Retries') IS NULL ALTER TABLE dbo.RunHistory ADD Retries int NOT NULL DEFAULT 0;
IF COL_LENGTH('dbo.RunHistory','ErrorAttempts') IS NULL ALTER TABLE dbo.RunHistory ADD ErrorAttempts int NOT NULL DEFAULT 0;
IF COL_LENGTH('dbo.RunHistory','Attempts') IS NULL ALTER TABLE dbo.RunHistory ADD Attempts int NOT NULL DEFAULT 0;
IF COL_LENGTH('dbo.RunHistory','RunStatus') IS NULL ALTER TABLE dbo.RunHistory ADD RunStatus nvarchar(40) NULL;
IF COL_LENGTH('dbo.RunHistory','ReportPath') IS NULL ALTER TABLE dbo.RunHistory ADD ReportPath nvarchar(1000) NULL;
IF COL_LENGTH('dbo.RunHistory','ReportError') IS NULL ALTER TABLE dbo.RunHistory ADD ReportError nvarchar(2000) NULL;
