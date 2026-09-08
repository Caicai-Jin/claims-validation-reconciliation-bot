-- OPTIONAL RECORDING: Run after the two-row retry demo described in the guide.
-- Read-only. Assumes ClaimIDs DEMOERR1 and DEMOOK1 were used.
USE ClaimsAutomationDemo1;
GO

-- Expected: DEMOOK1 APPROVED; no saved record for DEMOERR1.
SELECT ClaimID, Status, ReasonCode
FROM dbo.ProcessedClaims
WHERE ClaimID IN (N'DEMOERR1', N'DEMOOK1')
ORDER BY ClaimID;

-- Expected latest run: TotalClaims 2, Approved 1, Rejected 0,
-- Failed 1, Attempts 3, ErrorAttempts 2, Retries 1, CompletedWithErrors.
SELECT TOP (1) RunID, TotalClaims, Approved, Rejected, Failed,
       Skipped, Attempts, ErrorAttempts, Retries, RunStatus, ReportPath
FROM dbo.RunHistory
ORDER BY RunID DESC;

-- Orchestrator's View Transactions shows the original failed attempt as Retried
-- and its retry as Failed with an Application exception.
