--------------------------------------------------------------------------------
-- DBArtisan Schema Extraction
-- FILE                : ACEN0500_130626_115658.sql
-- DATE                : 06/26/2013 09:58:33.716
-- DATASOURCE          : ACEN0500 (SQLServer)
-- VERSION             : 09.00.5057
--------------------------------------------------------------------------------

--
-- Configuration Parameters
--

--
-- Target Database: master
--
USE master
go
EXEC sp_configure 'Ad Hoc Distributed Queries',0
go
EXEC sp_configure 'affinity I/O mask',0
go
EXEC sp_configure 'affinity mask',0
go
EXEC sp_configure 'affinity64 I/O mask',0
go
EXEC sp_configure 'affinity64 mask',0
go
EXEC sp_configure 'Agent XPs',1
go
EXEC sp_configure 'allow updates',0
go
EXEC sp_configure 'awe enabled',0
go
EXEC sp_configure 'blocked process threshold',0
go
EXEC sp_configure 'c2 audit mode',0
go
EXEC sp_configure 'clr enabled',0
go
EXEC sp_configure 'common criteria compliance enabled',0
go
EXEC sp_configure 'cost threshold for parallelism',5
go
EXEC sp_configure 'cross db ownership chaining',0
go
EXEC sp_configure 'cursor threshold',-1
go
EXEC sp_configure 'Database Mail XPs',1
go
EXEC sp_configure 'default full-text language',1033
go
EXEC sp_configure 'default language',0
go
EXEC sp_configure 'default trace enabled',1
go
EXEC sp_configure 'disallow results from triggers',0
go
EXEC sp_configure 'fill factor (%)',0
go
EXEC sp_configure 'ft crawl bandwidth (max)',100
go
EXEC sp_configure 'ft crawl bandwidth (min)',0
go
EXEC sp_configure 'ft notify bandwidth (max)',100
go
EXEC sp_configure 'ft notify bandwidth (min)',0
go
EXEC sp_configure 'index create memory (KB)',0
go
EXEC sp_configure 'in-doubt xact resolution',0
go
EXEC sp_configure 'lightweight pooling',0
go
EXEC sp_configure 'locks',0
go
EXEC sp_configure 'max degree of parallelism',0
go
EXEC sp_configure 'max full-text crawl range',4
go
EXEC sp_configure 'max server memory (MB)',28672
go
EXEC sp_configure 'max text repl size (B)',65536
go
EXEC sp_configure 'max worker threads',0
go
EXEC sp_configure 'media retention',0
go
EXEC sp_configure 'min memory per query (KB)',1024
go
EXEC sp_configure 'min server memory (MB)',0
go
EXEC sp_configure 'nested triggers',1
go
EXEC sp_configure 'network packet size (B)',4096
go
EXEC sp_configure 'Ole Automation Procedures',0
go
EXEC sp_configure 'open objects',0
go
EXEC sp_configure 'PH timeout (s)',60
go
EXEC sp_configure 'precompute rank',0
go
EXEC sp_configure 'priority boost',0
go
EXEC sp_configure 'query governor cost limit',0
go
EXEC sp_configure 'query wait (s)',-1
go
EXEC sp_configure 'recovery interval (min)',0
go
EXEC sp_configure 'remote access',1
go
EXEC sp_configure 'remote admin connections',0
go
EXEC sp_configure 'remote login timeout (s)',20
go
EXEC sp_configure 'remote proc trans',0
go
EXEC sp_configure 'remote query timeout (s)',600
go
EXEC sp_configure 'Replication XPs',0
go
EXEC sp_configure 'scan for startup procs',0
go
EXEC sp_configure 'server trigger recursion',1
go
EXEC sp_configure 'set working set size',0
go
EXEC sp_configure 'show advanced options',1
go
EXEC sp_configure 'SMO and DMO XPs',1
go
EXEC sp_configure 'SQL Mail XPs',0
go
EXEC sp_configure 'transform noise words',0
go
EXEC sp_configure 'two digit year cutoff',2049
go
EXEC sp_configure 'user connections',0
go
EXEC sp_configure 'user options',0
go
EXEC sp_configure 'Web Assistant Procedures',0
go
EXEC sp_configure 'xp_cmdshell',1
go
