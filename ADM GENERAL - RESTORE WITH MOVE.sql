USE MASTER
go

RESTORE FILELISTONLY FROM DISK = 'E:\DBA_Andres\DBA.bak'
go
RESTORE DATABASE DBA FROM DISK = 'E:\DBA_Andres\DBA.bak'
WITH 
MOVE 'DBA_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DBA.mdf',
MOVE 'DBA_Log'  TO 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\DBA.ldf'
go