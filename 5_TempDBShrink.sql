/*TempDB Total Files Size*/
USE tempdb;
SELECT 
    DB_NAME() AS DatabaseName,
    SUM(CASE WHEN type_desc = 'ROWS' THEN size ELSE 0 END) / 128.0 AS TotalDataFilesSizeInMB,
	SUM(CASE WHEN type_desc = 'ROWS' THEN FILEPROPERTY(name, 'SpaceUsed') ELSE 0 END)/128.0 AS TotalDataSpaceUsedInMB,
	SUM(CASE WHEN type_desc = 'ROWS' THEN size  - FILEPROPERTY(name, 'SpaceUsed') ELSE 0 END)/128.0 AS TotalFreeSpaceInMB,
    SUM(CASE WHEN type_desc = 'LOG' THEN size ELSE 0 END) / 128.0 AS TotalLogFileSizeInMB,
	SUM(CASE WHEN type_desc = 'LOG' THEN FILEPROPERTY(name, 'SpaceUsed') ELSE 0 END)/128.0 AS TotalLogSpaceUsedInMB
FROM sys.database_files;


USE [tempdb]
GO
DBCC SHRINKDATABASE(N'tempdb' )
GO

