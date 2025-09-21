USE DBATEST;

/* Reads from Version Store */
SELECT * FROM dbo.t1; 
GO

/* 
Reads uncommitted data
Overrides Isolation level
*/
SELECT * FROM dbo.t1 WITH (NOLOCK); 
GO
