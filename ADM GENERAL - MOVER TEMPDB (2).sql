
use master
go

ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev02, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb02.ndf')
GO
ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev03, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb03.ndf')
GO
ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev04, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb04.ndf')
GO
ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev05, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb05.ndf')
GO
ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev06, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb06.ndf')
GO
ALTER DATABASE tempdb 
	MODIFY FILE (NAME = tempdev07, FILENAME = 'L:\MSSQL.1\MSSQL\Data\tempdb07.ndf')
GO