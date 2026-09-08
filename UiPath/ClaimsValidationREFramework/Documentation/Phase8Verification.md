# Phase 8 — Reporting and logging

All six steps completed and verified on September 8, 2026.

## What happens on each run

Main.xaml creates a run ID and UTC start time. Every acknowledged queue attempt is recorded in memory, including its claim fields, outcome, reason, and retry number. At End Process, FinalizeRun.xaml creates an Excel workbook with Summary and Details sheets, saves a parameterized SQL RunHistory row, and closes both database connections.

Reports are saved in `SampleData/Reports` for the original configuration. An optional `ReportFolder` setting overrides the location. Filenames include the UTC start time and run ID. No new manual reporting step is required: run Main.xaml normally.

RunHistory's additional columns are installed by `Database/07_RunHistoryReporting.sql`. Run that script when setting up another database. Existing claim records and prior RunHistory rows are preserved.

## Counting rules

- TotalClaims: distinct ClaimIDs handled during this run.
- Approved, Rejected, Failed, Skipped: last outcome for each ClaimID in this run. Their sum equals TotalClaims; Excel's Reconciliation cell should be zero.
- Attempts: every queue attempt. ErrorAttempts includes technical errors even when a later retry succeeds. Retries counts attempts with a queue retry number above zero.
- Skipped means the ClaimID was already saved in SQL before this attempt; its existing decision is preserved.
- Failed describes the last technical-error outcome in this run, not a guarantee that no later run can recover it.
- Details contains one row per attempt. Amount and ServiceDate retain their raw queue input so malformed values remain visible.

## Verified results

| Scenario | Result |
|---|---|
| Live queue processing, isolated database | 22 claims: 9 approved, 12 rejected, 1 failed; 23 attempts, 2 error attempts, 1 retry |
| Excel and SQL reconciliation | Summary matched RunHistory; Details contained all 23 attempts; outcome totals reconciled |
| Already-saved claim | 1 skipped, 0 new approvals/rejections, no duplicate SQL insert |
| Invalid report output location | ReportingFailed row saved with the error; both database connections closed; execution explicitly failed |
| Unavailable database | Failure workbook generated with the initialization error; execution explicitly failed; no false RunHistory-success message |
| Final original configuration, empty queue | Completed; zero Error/Fatal log entries; workbook and RunHistory saved; both connections closed |
| Original claims database | Unchanged: 8 approved and 12 rejected |

The deliberate fault tests are expected failures. They verified that reporting errors are visible and cleanup runs before the error propagates. Database outages cannot write RunHistory while the database is unavailable; the workbook and execution log retain the evidence.

The verified nonempty sample is `SampleData/Reports/Phase8_VerifiedSample.xlsx`. It contains synthetic test data and intentionally shows CompletedWithErrors for the retry test. The final production package is version 1.0.306. Detailed test evidence and assertions are in `.work/phase8/` at the repository root.

Run start, transaction outcomes, retries/errors, run summary, RunHistory save, and connection closure are logged. A forcibly terminated process may not reach End Process and therefore may not produce a final workbook or history row; start and transaction logs remain available.
