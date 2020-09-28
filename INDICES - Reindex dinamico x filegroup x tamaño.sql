/* SP reindex dinamico por filegroup final 2009/11/19
*/

create procedure [dbo].[sp_reindex_dinamico_filegroup]
	@base varchar(30), 
	@filegroup varchar(30)
as
set nocount on


declare @CMD varchar(1000), @CMD2 varchar(1000), @inicioTabla datetime, @finTabla datetime, @inicioProceso datetime, @finProceso datetime

select  @inicioProceso = getdate()

CREATE TABLE #table(ownername varchar(500), tablename varchar(500), filegroupname varchar(30), SCRIPT VARCHAR(1000))

if @filegroup <>''
select @CMD2 = 'INSERT INTO #table
select DISTINCT d.name, a.name, ''' + @filegroup + ''', ''use ' + @base + ' DBCC DBREINDEX ("'' + d.name + ''.'' + a.name + ''"," ",0)''
from ' + @base + '..sysobjects a join ' + @base + '..sysindexes b on a.id = b.id
	join ' + @base + '..sysfilegroups c on b.groupid = c.groupid
	join ' + @base + '..sysusers d on a.uid = d.uid
where xtype = ''U'' and c.groupname = ''' + @filegroup + ''''


else
select @CMD2 = 'INSERT INTO #table (ownername, tablename, SCRIPT)
select DISTINCT d.name, a.name, ''use ' + @base + ' DBCC DBREINDEX ("'' + d.name + ''.'' + a.name + ''"," ",0)''
from ' + @base + '..sysobjects a join ' + @base + '..sysindexes b on a.id = b.id
	join ' + @base + '..sysfilegroups c on b.groupid = c.groupid
	join ' + @base + '..sysusers d on a.uid = d.uid
where xtype = ''U'' '


select @cmd2

exec (@CMD2)

while (select count(*) from #table) <> 0
begin

select  @inicioTabla = getdate()
select top 1 @CMD = SCRIPT from #table

print '
' + @CMD + ' Inicio ' + cast(@inicioTabla as varchar) + ' 
 '
--exec (@CMD)

select  @finTabla = getdate()

print '
 Fin ' + cast(@finTabla as varchar) + ' Total Tabla ' + cast(datediff(mi, @finTabla, @inicioTabla) as varchar)

delete #table where SCRIPT = @CMD
end

drop table #table

select @finProceso = getdate()

Print '
Inicio del Reindex ' + cast(@inicioProceso as varchar) + ' fin del Reindex ' + cast(@finProceso as varchar) + '
 Tiempo total (Minutos) ' + cast(datediff(mi, @finProceso, @inicioProceso) as varchar)
go