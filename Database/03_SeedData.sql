USE ClaimsAutomation;
GO

INSERT INTO dbo.Members (
    MemberID,
    CoverageStart,
    CoverageEnd,
    PlanType
)
VALUES
    ('M001', '20260101', '20261231', 'Standard'),
    ('M002', '20260101', '20261231', 'Standard'),
    ('M003', '20260101', '20261231', 'Standard'),
    ('M004', '20260101', '20260831', 'Standard');
GO

SELECT * FROM dbo.Members;

USE ClaimsAutomation;
GO

INSERT INTO dbo.Providers (
    ProviderID,
    ProviderName
)
VALUES
    ('P100', 'Sample Dental'),
    ('P101', 'Sample Vision'),
    ('P102', 'Sample Pharmacy');
GO

SELECT * FROM dbo.Providers;



USE ClaimsAutomation;
GO

INSERT INTO dbo.CoverageLimits (
    PlanType,
    ServiceType,
    MaxAmount
)
VALUES
    ('Standard', 'Dental', 500.00),
    ('Standard', 'Vision', 300.00),
    ('Standard', 'Drug', 100.00);
GO

SELECT * FROM dbo.CoverageLimits;



