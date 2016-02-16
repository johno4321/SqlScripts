SELECT 
	getutcdate() AS TimestampVal
	,conns.session_id AS SessionId
	,db_name(prc.dbid) AS DbName
	,conns.connect_time AS ConnectTime
	,conns.last_read AS LastRead
	,conns.last_write AS LastWrite
	,sess.program_name AS ProgramName
	,sess.host_process_id AS HostProcessId
	,sess.login_name AS LoginName
	,sqlText.text AS SqlText
FROM 
	sys.dm_exec_connections conns
CROSS APPLY 
	sys.dm_exec_sql_text(conns.most_recent_sql_handle) sqlText
INNER JOIN 
	sys.dm_exec_sessions sess ON sess.session_id = conns.session_id
INNER JOIN 
	master..sysprocesses prc ON conns.session_id = prc.spid