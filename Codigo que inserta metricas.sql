DECLARE @SQLProcessUtilization int;
DECLARE @PageReadsPerSecond bigint
DECLARE @PageWritesPerSecond bigint
DECLARE @CheckpointPagesPerSecond bigint
DECLARE @LazyWritesPerSecond bigint
DECLARE @BatchRequestsPerSecond bigint
DECLARE @CompilationsPerSecond bigint
DECLARE @ReCompilationsPerSecond bigint
DECLARE @PageLookupsPerSecond bigint
DECLARE @TransactionsPerSecond bigint
DECLARE @stat_date datetime

-- Table for First Sample
DECLARE @RatioStatsX TAbLE(
[object_name] varchar(128)
,[counter_name] varchar(128)
,[instance_name] varchar(128)
,[cntr_value] bigint
,[cntr_type] int
)

INSERT INTO @RatioStatsX (
[object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] )
SELECT [object_name]
,[counter_name]
,[instance_name]
,[cntr_value]
,[cntr_type] FROM sys.dm_os_performance_counters

SET @stat_date = getdate()

SELECT TOP 1 @PageReadsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page reads/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END

SELECT TOP 1 @PageWritesPerSecond= cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END

SELECT TOP 1 @CheckpointPagesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Checkpoint pages/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END

SELECT TOP 1 @LazyWritesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Lazy writes/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END

SELECT TOP 1 @BatchRequestsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Batch Requests/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END

SELECT TOP 1 @CompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END

SELECT TOP 1 @ReCompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Re-Compilations/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:SQL Statistics'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics' END

SELECT TOP 1 @PageLookupsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page lookups/sec'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager' END

SELECT TOP 1 @TransactionsPerSecond=cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Transactions/sec' AND instance_name = '_Total'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Databases'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Databases' END


select * from @RatioStatsX

