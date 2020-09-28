/* SP reindex dinamico por filegroup final 2009/11/19
*/

alter procedure [dbo].[sp_reindex_dinamico_filegroup]
	@base varchar(30), 
	@filegroup varchar(30)
as
set nocount on

declare @CMD varchar(1000), @CMD2 varchar(1000), @inicioTabla datetime, @finTabla datetime, @inicioProceso datetime, @finProceso datetime

select  @inicioProceso = getdate()

CREATE TABLE #table(ownername varchar(30), tablename varchar(30), filegroupname varchar(30), SCRIPT VARCHAR(1000))

select @CMD2 = 'INSERT INTO #table
select DISTINCT d.name, a.name, ''' + @filegroup + ''', ''use ' + @base + ' DBCC DBREINDEX ("'' + d.name + ''.'' + a.name + ''"," ",0)''
from ' + @base + '..sysobjects a join ' + @base + '..sysindexes b on a.id = b.id
	join ' + @base + '..sysfilegroups c on b.groupid = c.groupid
	join ' + @base + '..sysusers d on a.uid = d.uid
where xtype = ''U'' and c.groupname = ''' + @filegroup + ''''

select @cmd2

exec (@CMD2)

while (select count(*) from #table) <> 0
begin

select  @inicioTabla = getdate()
select top 1 @CMD = SCRIPT from #table

print '
' + @CMD + ' Inicio ' + cast(@inicioTabla as varchar) + ' 
 '
exec (@CMD)

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
 
 
 
 /* Anterior sin consulta dinamica
 */
 
 
 CREATE procedure [dbo].[sp_reindex_dinamico_filegroup]
	@base varchar(30), 
	@filegroup varchar(30)
as
set nocount on

exec ('use ' + @base)

declare @CMD varchar(1000), @inicioTabla datetime, @finTabla datetime, @inicioProceso datetime, @finProceso datetime

select  @inicioProceso = getdate()

CREATE TABLE #table(ownername varchar(30), tablename varchar(30), filegroupname varchar(30), SCRIPT VARCHAR(1000))

INSERT INTO #table
select DISTINCT user_name(a.uid), a.name, @filegroup, 'use ' + @base + ' DBCC DBREINDEX ("' + user_name(a.uid) + '.' + a.name + '")'
from sysobjects a join sysindexes b on a.id = b.id
	join sysfilegroups c on b.groupid = c.groupid
where xtype = 'U' and c.groupname = @filegroup

while (select count(*) from #table) <> 0
begin

select  @inicioTabla = getdate()
select top 1 @CMD = SCRIPT from #table

print '
' + @CMD + ' Inicio ' + cast(@inicioTabla as varchar) + ' 
 '
exec (@CMD)

select  @finTabla = getdate()

print '
 Fin ' + cast(@finTabla as varchar) + 'Total Tabla ' + cast(datediff(mi, @finTabla, @inicioTabla) as varchar)

delete #table where SCRIPT = @CMD
end

drop table #table

select @finProceso = getdate()

Print '
Inicio del Reindex ' + cast(@inicioProceso as varchar) + ' fin del Reindex ' + cast(@finProceso as varchar) + '
 Tiempo total (Minutos) ' + cast(datediff(mi, @finProceso, @inicioProceso) as varchar)

