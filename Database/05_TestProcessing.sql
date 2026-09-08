USE ClaimsAutomation;
GO

INSERT INTO dbo.ProcessedClaims (
    ClaimID,
    MemberID,
    ProviderID,
    ServiceDate,
    Amount,
    ServiceType,
    [Status],
    ReasonCode
)
VALUES (
    'C1001',
    'M001',
    'P100',
    '20260810',
    120.00,
    'Dental',
    'APPROVED',
    NULL
);
GO

SELECT *
FROM dbo.ProcessedClaims
WHERE ClaimID = 'C1001';



GO

BEGIN TRANSACTION;

INSERT INTO dbo.ProcessedClaims (
    ClaimID,
    MemberID,
    ProviderID,
    ServiceDate,
    Amount,
    ServiceType,
    [Status],
    ReasonCode
)
VALUES (
    'C1013',
    'M001',
    'P100',
    '20260819',
    700.00,
    'Dental',
    'REJECTED',
    'COVERAGE_LIMIT_EXCEEDED'
);

SELECT *
FROM dbo.ProcessedClaims
WHERE ClaimID = 'C1013';

ROLLBACK TRANSACTION;
GO

GO

-- C1013 should be absent because we rolled back its insert.
SELECT COUNT(*) AS RejectedTestRows
FROM dbo.ProcessedClaims
WHERE ClaimID = 'C1013';

-- Remove the approved claim we inserted for testing.
DELETE FROM dbo.ProcessedClaims
WHERE ClaimID = 'C1001';

-- The table should now be empty.
SELECT COUNT(*) AS RemainingProcessedClaims
FROM dbo.ProcessedClaims;
GO