USE [msdb]
GO
SELECT	j.job_id,
	s.srvname,
	j.name,
	js.step_id,
	js.command,
	j.enabled 
FROM	dbo.sysjobs j
JOIN	dbo.sysjobsteps js
	ON	js.job_id = j.job_id 
JOIN	master.dbo.sysservers s
	ON	s.srvid = j.originating_server_id
WHERE	j.name='PRT - Procesos correctivos' and
js.command LIKE N'%PRT_SiniestrosPeriodos%'
GO