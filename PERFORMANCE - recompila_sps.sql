set nocount on
declare @databases table (nro int identity, dbname varchar(255))
declare @dbname varchar(255), @command varchar(1000), @cont int
insert @databases(dbname) select '[' + name  + ']' from master..sysdatabases
 where name not in ('master', 'model', 'msdb', 'tempdb', 'northwind', 'pubs', 'distribution', 'distribution1', 'distribution2', 'distribution3', 'DBA', 'system', 'mantenimiento')
 order by name desc
select @cont = max(nro) from @databases
while  @cont <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont
    select 'select ''' + 'use ' + @dbname + ''''
    select 'select ''' + 'go' + ''''
    select @command = 'use ' + @dbname + ' exec (''select ''''exec sp_recompile ''''''''['''' + u.name + ''''].['''' + o.name + '''']'''''''''''' from sysobjects o join sysusers u on o.uid = u.uid where o.type = ''''P'''' and o.name not like ''''dt_%'''' order by o.name, u.name'')'
    select @command
    select @cont = @cont - 1
  end
go
                                                                                                                                                                                                                                                                 


