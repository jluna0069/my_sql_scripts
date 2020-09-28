use piscys
go
SELECT
TOP (10)

COALESCE(DB_NAME(st.dbid),DB_NAME(CAST(pa.value AS INT))+'*', 'Resource') AS [Database Name] 

,SUBSTRING(text,CASE WHEN statement_start_offset = 0 OR statement_start_offset IS NULL THEN 1 

ELSE statement_start_offset/2 + 1 END,CASE WHEN statement_end_offset = 0 OR statement_end_offset = -1 OR statement_end_offset IS NULL 

THEN LEN(text)  ELSE statement_end_offset/2 END - CASE WHEN statement_start_offset = 0 OR statement_start_offset IS NULL THEN 1 

ELSE statement_start_offset/2  END + 1 )  AS [Statement]

,OBJECT_SCHEMA_NAME(st.objectid,dbid) [Schema Name]

,OBJECT_NAME(st.objectid,dbid) [Object Name]

,objtype [Cached Plan objtype]

,execution_count [Execution Count]

,(total_logical_reads + total_logical_writes + total_physical_reads )/execution_count [Average IOs]

,total_logical_reads + total_logical_writes + total_physical_reads [Total IOs]

,total_logical_reads/execution_count [Avg Logical Reads]

,total_logical_reads [Total Logical Reads]

,total_logical_writes/execution_count [Avg Logical Writes]

,total_logical_writes [Total Logical Writes]

,total_physical_reads/execution_count [Avg Physical Reads]

,total_physical_reads [Total Physical Reads]

,total_worker_time / execution_count [Avg CPU]

,total_worker_time [Total CPU]

,total_elapsed_time / execution_count [Avg Elapsed Time]

,total_elapsed_time  [Total Elasped Time]

,last_execution_time [Last Execution Time]

FROM sys.dm_exec_query_stats qs

JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle

CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st

OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa

WHERE attribute = 'dbid'

AND     CASE when 'PISCYS' = '<not supplied>' THEN '<not supplied>' ELSE COALESCE(DB_NAME(st.dbid),DB_NAME(CAST(pa.value AS INT)) + '*', 'Resource') END

IN (RTRIM('PISCYS'),RTRIM('PISCYS') + '*')  