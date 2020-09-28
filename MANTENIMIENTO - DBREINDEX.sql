USE EdesurDB
go
exec sp_MSforeachtable 'DBCC DBREINDEX ("?")'
go