
/* Enable RCSI */

--Check snapshot options status
SELECT snapshot_isolation_state,is_read_committed_snapshot_on, name
FROM sys.databases
WHERE name ='DBATest';











--Check if there are any active transactions
EXEC sp_WhoIsActive
    @filter_type = 'database',
    @filter = 'DBATest'





--This stores the row versions in tempdb, before write operations begin.
ALTER DATABASE DBATest
SET ALLOW_SNAPSHOT_ISOLATION ON 








--This allows all queries in this database to access the versioned rows in tempdb.
--Needs exclusive access
ALTER DATABASE DBATest
SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE












--Verify options are enabled
SELECT snapshot_isolation_state,is_read_committed_snapshot_on, name
FROM sys.databases
WHERE name ='DBATest'










USE DBATEST;
DBCC USEROPTIONS







--Run update
USE DBATEST;
BEGIN TRAN
UPDATE dbo.t1 SET b='b_1' WHERE id=1;






--Run 2a_Select.sql
--Run 2b_LocksGranted.sql

--Commit after reviewing the blocking
COMMIT

/*
TAKEAWAY:

**In RCSI, reads do not get blocked by writes unlike read committed isolation level.

**Here, reads do not need S lock as they read the versioned rows in tempdb 
  and that’s why they don’t get blocked by writes which has X lock.

**Behavior of write operations remain the same.

**Blocking still exists between write operations. 

**Only the behavior of reads change as they read from version store 
  and as a result won’t get blocked by writes.

**NOLOCK hint overrides RCSI 

*/








--Set database back to multi user
--ALTER DATABASE DBATest 
--SET MULTI_USER WITH ROLLBACK IMMEDIATE 