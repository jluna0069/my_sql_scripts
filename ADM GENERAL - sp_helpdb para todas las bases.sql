USE master
go
exec sp_MSforeachdb 'sp_helpdb "?"'
go