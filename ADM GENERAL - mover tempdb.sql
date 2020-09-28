-- alter database tempdb modify file (name = 'tempdev', filename = 'F:\mssql\data\tempdev.mdf')

USE master;
GO
ALTER DATABASE tempdb 
MODIFY FILE (NAME = tempdev, FILENAME = 'E:\SQLData\tempdb.mdf');
GO
ALTER DATABASE  tempdb 
MODIFY FILE (NAME = templog, FILENAME = 'E:\SQLData\templog.ldf');
GO


