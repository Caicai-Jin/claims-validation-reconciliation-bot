# Phase 7: Orchestrator queue

All seven steps completed and tested on September 7, 2026.

## Run the project

1. Sign in to UiPath Assistant with your connected account.
2. In Studio, open **UploadClaims.xaml** and choose **Run File**. This reads the configured Excel workbook and uploads each ClaimID once.
3. Open **Main.xaml** and run it. REFramework retrieves and processes queue items until the queue is empty.
4. In Orchestrator, open **Shared > Queues > ClaimsValidationQueue > View Transactions** to see outcomes.

Config.xlsx uses ClaimsValidationQueue in Shared. The queue enforces unique references and one automatic retry. Local MaxRetryNumber is 0 so retries are not doubled. QueueItem data is converted into one DataRow for the existing validation and parameterized SQL save workflows.

Successful validation marks the queue transaction Successful. A saved rejection produces a Business failure with its reason and no retry. Technical failures produce an Application failure; Orchestrator owns the retry. Existing SQL ClaimIDs are not inserted again, and stored rejection reasons are preserved on redelivery.

## Verified results

| Test | Result |
|---|---|
| Upload | 22 synthetic claims added |
| Repeat upload | 0 added, 22 already queued |
| Valid claims | 9 Successful |
| Invalid claims | 12 Failed with Business reasons; no business retries |
| Deliberately malformed C1021 | Original attempt Retried, retry Failed with Application error; exactly two attempts |
| Continue after failure | C1022 approved |
| SQL test database | 21 rows: 9 approved, 12 rejected; no C1021 row |
| Cleanup | Three confirmed connection closes during the fault test |
| Final original-config Main run | Empty queue, normal completion, zero Error/Fatal entries |

Orchestrator showed 23 transaction records: 22 originals plus one retry. All were terminal, with no New or In Progress items. The deliberate Application failure is test evidence, not an unexpected project failure.

The test used the separate ClaimsAutomation_Phase7Checks database. Your original ClaimsAutomation database remains at 8 approved and 12 rejected records. Production Config still points to that original database and SampleData/claims.xlsx. Queue references from the tests remain visible; uploading the same 20 sample IDs again skips them. For another live demo, use new synthetic ClaimIDs and valid, nonduplicate claim details in a separate input workbook.

Phase 6 backup and detailed evidence are in `.work/phase7/` at the repository root. The final locally compiled package is version 1.0.205; the isolated test package is 1.0.204. These are attended Studio/Robot runs; no unattended trigger or schedule is required.
