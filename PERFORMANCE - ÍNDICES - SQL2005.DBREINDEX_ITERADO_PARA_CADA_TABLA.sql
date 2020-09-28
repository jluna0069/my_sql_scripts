USE xxxx
go
exec sp_MSforeachtable 'DBCC DBREINDEX ("?")'
go