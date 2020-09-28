use sysdba
go
SELECT 
		[Spid],
		[Status],
		[User],
		[Host_name],
		[Program],
		[blocking_session_id],
		[Database],
		[sql_Statement],
		[cpu_time],
		[reads],
		[writes],
		[logical_reads],
		[row_count],
		[Start_time],
		[DifSegundos]
	FROM  [SYSDBA].[dbo].[TBL_ProcesosUnMinuto]
	WHERE [start_time] >= dateadd(Mi, datediff(Mi, 0, getdate())-120,0)
	ORDER BY start_time DESC