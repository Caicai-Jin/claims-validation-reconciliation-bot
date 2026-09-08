USE ClaimsAutomation;
GO

CREATE TABLE dbo.Members (
    MemberID NVARCHAR(20) NOT NULL PRIMARY KEY,
    CoverageStart DATE NOT NULL,
    CoverageEnd DATE NOT NULL,
    PlanType NVARCHAR(30) NOT NULL
);
GO

USE ClaimsAutomation;
GO

CREATE TABLE dbo.Providers (
    ProviderID NVARCHAR(20) NOT NULL PRIMARY KEY,
    ProviderName NVARCHAR(100) NOT NULL
);
GO

USE ClaimsAutomation;
GO

SELECT * FROM dbo.Providers;

USE ClaimsAutomation;
GO

CREATE TABLE dbo.CoverageLimits (
    PlanType NVARCHAR(30) NOT NULL,        --The insurance package a member has,  e.g. Standard or Gold
    ServiceType NVARCHAR(30) NOT NULL,     --The category of healthcare service,  e.g. Dental or Vision
    MaxAmount DECIMAL(10, 2) NOT NULL,     ---- Maximum allowed per claim in CAD
    PRIMARY KEY (PlanType, ServiceType)
);
GO

USE ClaimsAutomation;
GO

CREATE TABLE dbo.ClaimsStaging (
    ClaimID NVARCHAR(20) NOT NULL PRIMARY KEY,
    MemberID NVARCHAR(20) NOT NULL,
    ProviderID NVARCHAR(20) NOT NULL,
    ServiceDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    ServiceType NVARCHAR(30) NOT NULL
);
GO


USE ClaimsAutomation;
GO

CREATE TABLE dbo.ProcessedClaims (
    ClaimID NVARCHAR(20) NOT NULL PRIMARY KEY,
    MemberID NVARCHAR(20) NOT NULL,
    ProviderID NVARCHAR(20) NOT NULL,
    ServiceDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    ServiceType NVARCHAR(30) NOT NULL,
    Status NVARCHAR(20) NOT NULL,       --the result, such as APPROVED or REJECTED
    ReasonCode NVARCHAR(1000) NULL,     --why it was rejected. NULL allows no reason for approved claims
                                        --Multiple reasons can be stored together
    ProcessedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
                                        --when processing finished—when the claim’s final result was recorded
                                        --SQL Server automatically supplies the current UTC time 
                                        --if we don’t provide one
);
GO

USE ClaimsAutomation;
GO

--One row represents one complete bot run. 
--For example: “Processed 20 claims: 8 approved, 12 rejected, 0 technical failures.”
CREATE TABLE dbo.RunHistory (
    RunID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    StartTime DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    EndTime DATETIME2 NULL,                 --When the run finished. Initially NULL because it’s still running
    TotalClaims INT NOT NULL DEFAULT 0,     --Number of claims included in the run
    Approved INT NOT NULL DEFAULT 0,        --Number that passed validation
    Rejected INT NOT NULL DEFAULT 0,        --Number rejected for business reasons, such as expired coverage
    Failed INT NOT NULL DEFAULT 0           --Number that could not finish because of technical problems,
                                            --such as a database error after retries
);
GO

