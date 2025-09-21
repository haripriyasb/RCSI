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
UPDATE dbo.t1 SET b='b_0';





/*
DISPLAY VERSIONED ROWS IN VERSION STORE
*/
SELECT COUNT(*) AS NumberOfVersionedRows 
FROM sys.dm_tran_version_store


/*
SPACE CONSUMED IN TEMPDB, BY VERSION STORE OF EACH DATABASE
*/

SELECT DB_NAME(database_id) AS 'Database Name'
	,reserved_space_kb  AS 'Space(KB) used in tempdb for version store'
FROM sys.dm_tran_version_store_space_usage
WHERE reserved_space_kb > 0
ORDER BY 1;









/*
FIND TRANSACTIONS USING VERSION STORE
*/
SELECT a.session_id, d.name, a.elapsed_time_seconds/60.00 AS elapsed_time_mins,
b.open_tran, b.status,b.program_name,  a.transaction_id, a.transaction_sequence_num
FROM sys.dm_tran_active_snapshot_database_transactions a
join sys.sysprocesses b on a.session_id = b.spid
join sys.databases d on b.dbid=d.database_id
ORDER BY elapsed_time_seconds DESC








COMMIT