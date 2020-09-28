alter procedure sp_DBAdm_io_virtual_file_stats
as

declare @dbname table(name varchar(100),
						id int)
declare @db varchar(100)
declare @dbid int
declare @getdate datetime

set @getdate = getdate()

insert into @dbname
SELECT name, database_id FROM sys.databases where name not in ('master','model','dba','msdb')

while (select count(*) from @dbname)<>0
begin

select top 1 @db = name, @dbid = id from @dbname

execute ('use ' + @db)

if (select @db) = 'tempdb'
	begin
		insert into DBAdm_io_virtual_file_stats
		select 	@getdate, @db, b.*
		from sys.dm_io_virtual_file_stats(@dbid, null) b
	end
else
	begin
		insert into DBAdm_io_virtual_file_stats
		select 	@getdate, @db, b.*
		from sysfiles a 
		join sys.dm_io_virtual_file_stats(@dbid, 2) b
			on a.fileid = b.file_id
		where filegroup_name(groupid) is null
	end

delete @dbname where name = @db

end

go