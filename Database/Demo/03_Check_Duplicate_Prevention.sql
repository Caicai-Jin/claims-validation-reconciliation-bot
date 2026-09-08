-- RECORDING: Run after uploading the same 20 claims again and rerunning Main.xaml.
-- Read-only. Run this before the optional retry demonstration.
USE ClaimsAutomationDemo1;
GO

SELECT COUNT(*) AS SavedClaims,
       CASE WHEN COUNT(*) = 20 THEN 'PASS: still 20 saved claims'
            ELSE 'CHECK: expected 20 before the optional retry demo'
       END AS Result
FROM dbo.ProcessedClaims;

-- Expected: no rows below.
SELECT ClaimID, COUNT(*) AS Copies
FROM dbo.ProcessedClaims
GROUP BY ClaimID
HAVING COUNT(*) > 1;

-- Expected after the empty-queue rerun: latest run has 0 claims and Completed status.
SELECT TOP (1) RunID, TotalClaims, Approved, Rejected, Failed,
       Skipped, Attempts, RunStatus, ReportPath
FROM dbo.RunHistory
ORDER BY RunID DESC;
