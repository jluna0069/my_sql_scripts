exec sp_MSforeachdb 'EXEC sp_updatestats
PRINT "?"'
go