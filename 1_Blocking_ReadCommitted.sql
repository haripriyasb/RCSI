
/*
Check blocking in Default Isolation - Read Committed
*/
USE DBATEST;
DBCC USEROPTIONS













USE DBATEST
GO
DROP TABLE IF EXISTS dbo.t1
GO

--Create table t1 with 1 million records
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
WHERE t1.k < 1000001 

--Explicit transaction 
BEGIN TRAN
UPDATE dbo.t1 SET b='b_0' WHERE ID=1;

--Run 1a_Select.sql
--Run 1b_LocksGranted.sql

--Commit after reviewing the blocking
COMMIT



/*

TAKEAWAY:
Read was blocked by write.

You could use NOLOCK, but you could be reading data that is uncommitted,
rolled back or duplicates and that is why it is called dirty reads.

So, If you’re frequently experiencing reads being blocked by writes, 
which usually happens on a very busy OLTP system, 
then you can take advantage of ‘READ COMMITTED SNAPSHOT’ isolation level.

*/