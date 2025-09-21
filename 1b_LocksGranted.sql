
--Blocking session
EXEC sp_WhoIsActive
    @find_block_leaders = 1,
    @sort_order = '[blocked_session_count] DESC'









--Locks granted/waited
SELECT request_session_id
	,resource_type
	,resource_description
	,request_type
	,request_mode
	,request_status
FROM sys.dm_tran_locks
WHERE request_session_id IN (71,60)


--commit in other window
