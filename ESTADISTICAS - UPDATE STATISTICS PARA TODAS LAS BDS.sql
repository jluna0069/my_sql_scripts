USE master
go

exec sp_MSforeachdb 
' IF (''?'' NOT IN (''master'',''tempdb'',''model'',''msdb'',''ReportServerTempDB''))
BEGIN PRINT ''Atualizando estat�sticas de '' + ''?''
use ? exec sp_updatestats END';
