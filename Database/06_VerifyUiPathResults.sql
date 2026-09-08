USE ClaimsAutomation;
GO

SELECT ClaimID, [Status], ReasonCode
FROM dbo.ProcessedClaims
ORDER BY ClaimID;

SELECT [Status], COUNT(*) AS ClaimCount
FROM dbo.ProcessedClaims
GROUP BY [Status];