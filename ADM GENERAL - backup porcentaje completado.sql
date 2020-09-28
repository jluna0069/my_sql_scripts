select session_id, command, percent_complete, start_time, ((100 * cast((getdate() - start_time) as int))/percent_complete) as restante  from sys.dm_exec_requests
where session_id = 62

select session_id, command, percent_complete, start_time, (getdate() - start_time) 
from sys.dm_exec_requests
where session_id = 62