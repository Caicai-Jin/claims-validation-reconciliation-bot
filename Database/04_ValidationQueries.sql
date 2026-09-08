USE ClaimsAutomation;
GO

DECLARE @MemberID NVARCHAR(20) = 'M001';

SELECT MemberID, CoverageStart, CoverageEnd, PlanType
FROM dbo.Members
WHERE MemberID = @MemberID;


GO

DECLARE @PlanType NVARCHAR(30) = 'Standard';
DECLARE @ServiceType NVARCHAR(30) = 'Dental';

SELECT MaxAmount
FROM dbo.CoverageLimits
WHERE PlanType = @PlanType
  AND ServiceType = @ServiceType;
GO


GO

DECLARE @DuplicateMemberID NVARCHAR(20) = 'M001';
DECLARE @ProviderID NVARCHAR(20) = 'P100';
DECLARE @ServiceDate DATE = '20260810';
DECLARE @Amount DECIMAL(10, 2) = 120.00;

SELECT COUNT(*) AS DuplicateCount
FROM dbo.ProcessedClaims
WHERE MemberID = @DuplicateMemberID
  AND ProviderID = @ProviderID
  AND ServiceDate = @ServiceDate
  AND Amount = @Amount;
GO

USE ClaimsAutomation;
GO

SELECT name AS TableName
FROM sys.tables
ORDER BY name;