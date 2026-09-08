# SSMS demo scripts

These scripts were saved for manual use and were not executed when created.

Connect SSMS to `(localdb)\MSSQLLocalDB` with Windows Authentication. Open a script using **File > Open > File**, then click **Execute**. Run the whole file, with no text selected.

1. **01_Setup_Demo1.sql** — run once before recording. Creates ClaimsAutomationDemo1 and copies reference data plus empty result-table schemas. It refuses to run if that database already exists. It does not change the original database. Do not create the demo database manually first when using this script.
2. **02_Show_Results.sql** — run after the first normal 20-claim demo to show decisions, totals, RunHistory, and the report location.
3. **03_Check_Duplicate_Prevention.sql** — run after the repeated upload and empty-queue rerun, before the optional retry demonstration.
4. **04_Check_Optional_Retry.sql** — run after the two-row DEMOERR1/DEMOOK1 retry demonstration, if included.

Only the setup script creates a database or tables. The other three scripts are read-only. None deletes results or resets a queue.

The bot must use queue ClaimsValidationDemo1 in Shared and database ClaimsAutomationDemo1 in Config.xlsx. Queue creation, configuration, and running UploadClaims.xaml/Main.xaml remain separate UiPath steps.

For another fresh demo, use a new database and queue name and update the database name in all four SQL files and Config.xlsx. Existing demo results are retained.
