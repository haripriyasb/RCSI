/*Verify RCSI enabled*/
USE DBATest;
SELECT snapshot_isolation_state,is_read_committed_snapshot_on, name
FROM sys.databases
WHERE name ='DBAtest'

DROP TABLE IF EXISTS dbo.t1
GO

--Create table t1 with 10 records
SELECT t1.k AS id
	,'a_' + cast(t1.k AS VARCHAR) AS a
	,'b_' + cast(t1.k / 2 AS VARCHAR) AS b
INTO t1
FROM (
	SELECT ROW_NUMBER() OVER (
			ORDER BY a.object_id
			) AS k
	FROM sys.all_columns
		,sys.all_columns a
	) t1
WHERE t1.k < 11 


BEGIN TRAN
UPDATE dbo.t1 SET b='b_0';

--Run another window 
COMMIT