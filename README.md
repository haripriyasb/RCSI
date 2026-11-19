# Maximize Performance Using Read Committed Snapshot Isolation (RCSI)

Demo scripts and slides from my session **Maximize Performance Using Read Committed Snapshot Isolation**, presented at SQL Saturday Boston.

Under SQL Server's default isolation level (Read Committed), readers and writers block each other. RCSI lets readers see the last committed version of a row from the version store instead of waiting, which can remove most blocking. This session covers how it works, what it costs in TempDB, and how it compares to Snapshot Isolation.

## What the demo shows

- Blocking between a writer and a reader under Read Committed
- Enabling RCSI and watching the same reader succeed without being blocked
- Inspecting the locks granted and waited on with `sp_WhoIsActive` and DMVs
- How the version store grows in TempDB and how it gets cleaned up
- Checking and shrinking TempDB after version store growth
- Why `NOLOCK` still reads uncommitted data even with RCSI on
- **Snapshot Isolation (SI)**: how readers are blocked until they opt in with `SET TRANSACTION ISOLATION LEVEL SNAPSHOT`

## Requirements

- SQL Server 2016 or later on a test instance
- Test databases named `DBATEST`, `VersionDB` and `FinAppDB`
- [sp_WhoIsActive](https://github.com/amachanic/sp_whoisactive) installed
- Two or more query windows (several demos use one session to block another)

## Run the demo

| Step | Script(s) | What it does |
|---|---|---|
| 1 | `1_Blocking_ReadCommitted.sql`, `1a_Select.sql`, `1b_LocksGranted.sql` | Creates blocking under Read Committed and inspects the locks |
| 2 | `2_RCSI.sql`, `2a_Select.sql`, `2b_LocksGranted.sql` | Enables RCSI and repeats the test |
| 3 | `3_VersionStore.sql` | Generates and measures version store usage |
| 4 | `4_Cleanup VersionStore.sql` | Shows how and when the version store is cleaned up |
| 5 | `5_TempDBShrink.sql` | Checks TempDB file sizes and free space |
| 6 | `6_NoLock override.sql`, `6a_SELECT WITH NOLOCK.sql` | Shows `NOLOCK` overriding RCSI and reading uncommitted data |
| 7 | `7_SI.sql`, `7a_SI_ReadBlocked.sql`, `7b_SI_VersionStore.sql` | Compares Snapshot Isolation with RCSI |

## Files

- `*.sql`: demo scripts, run in numbered order
- `Maximize Performance Using Read Committed Snapshot Isolation.pdf`: session slides

## Learn more

- [Transaction locking and row versioning guide (Microsoft Learn)](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide)
- Blog: [gohigh.substack.com](https://gohigh.substack.com)

> These scripts drop and recreate tables and change database settings. Run them only on a test instance.
