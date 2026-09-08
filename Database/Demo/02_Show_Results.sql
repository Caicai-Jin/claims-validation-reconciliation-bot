-- RECORDING: Run after UploadClaims.xaml and the first Main.xaml demo run.
-- Read-only. Expected before the optional retry demo: 20 rows, 8 approved, 12 rejected.
USE ClaimsAutomationDemo1;
GO

SELECT ClaimID, MemberID, ProviderID, ServiceDate,
       Amount, ServiceType, Status, ReasonCode
FROM dbo.ProcessedClaims
ORDER BY ClaimID;

SELECT Status, COUNT(*) AS ClaimCount
FROM dbo.ProcessedClaims
GROUP BY Status
ORDER BY Status;

SELECT TOP (5)
       RunID, StartTime, EndTime, TotalClaims,
       Approved, Rejected, Failed, Skipped,
       Attempts, ErrorAttempts, Retries,
       RunStatus, ReportPath
FROM dbo.RunHistory
ORDER BY RunID DESC;

-- First run: TotalClaims 20, Approved 8, Rejected 12, Failed 0,
-- Skipped 0, Attempts 20, ErrorAttempts 0, Retries 0, RunStatus Completed.
