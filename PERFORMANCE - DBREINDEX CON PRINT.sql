USE EdesurDB
go
exec sp_MSforeachtable 'DBCC DBREINDEX ("?")
PRINT "?"
CHEKPOINT
go'
go