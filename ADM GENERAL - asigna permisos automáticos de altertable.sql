USE [DBA]
GO
/****** Object:  StoredProcedure [dbo].[asigna_permisos_alterTable]    Script Date: 10/20/2010 10:32:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER procedure [dbo].[asigna_permisos_alterTable]
as
set nocount on
declare @databases table (nro int identity, dbname varchar(500))
create table #permisos (nro int identity, permiso varchar(500))
declare @dbname  varchar(500), @cont1 int
declare @permiso varchar(500), @cont2 int
insert @databases(dbname) select '[' + name  + ']' from master.sys.databases
where name not in ('master', 'model', 'msdb', 'tempdb', 'northwind', 'pubs', 'distribution', 'distribution1', 'distribution2', 'distribution3', 'DBA', 'system', 'mantenimiento')
and state_desc = 'ONLINE' order by name desc
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont1
    truncate table #permisos
    select @permiso = 'use ' + @dbname + ' exec ("insert #permisos(permiso) select ''GRANT ALTER ON ['' + u.name + ''].['' + o.name + ''] to Role_AlterTable'' from dbo.sysobjects o join sys.schemas u on o.uid = u.schema_id where type = ''U'' order by u.name desc, o.name desc")'
    exec  (@permiso)
    select @cont2 = max(nro) from #permisos
    while  @cont2 <> 0
      begin
        select @permiso = 'use ' + @dbname + ' exec ("' + (select permiso from #permisos where nro = @cont2) + '")'
        exec (@permiso)
		 select @cont2 = @cont2 - 1
      end
    select @cont1 = @cont1 - 1
  end
