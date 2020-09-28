USE [C24]
go
DBCC DBREINDEX ('[c24].[SFBMSTPT]', ' ', 0)
go

USE C24
go
exec sp_MSforeachtable 'DBCC DBREINDEX ("?","",0)
PRINT "?"'
go