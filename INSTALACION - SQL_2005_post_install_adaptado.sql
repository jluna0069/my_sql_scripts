/***********************************************************
*                                                          *
*   Configura el SQL Server 2005 luego de la instalación   *
*                                                          *
*            Administradores de Bases de Datos			   *
*														   *
*            Ultima Modificación: 23/05/2012               *
*                                                          *
***********************************************************/

/* NOTAS:                                                                                                      */
/* Ejecutar este script luego de una instalación conforme a las normas del documento de						   */
/* Instalación de una instancia SQL Server 2005;													           */
/* también puede ejecutarse en cualquier instalación ya operativa de SQL Server.                               */



/*******************************************************************
   Setea en '1' la opción 'show advanced options' del SQL Server
*******************************************************************/
set nocount on
select 'SETEA EN "1" LA OPCIÓN "SHOW ADVANCED OPTIONS" DEL SQL SERVER'
exec master.dbo.sp_configure 'show advanced options', 1
go
reconfigure with override
go


/*******************************************************************
   Setea en '1' la opción 'xp_cmdshell' del SQL Server
*******************************************************************/
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
go
-- To update the currently configured value for this feature.
reconfigure with override
go

select 'OPCIONES DEL SQL SERVER'
exec master.dbo.sp_configure
go


/**********************************************************************************************************
   Agrega a 'IT_BaseDatos' y 'srv_sqlserver' como SysAdmin y quita el acceso a 'Administrators' local
***********************************************************************************************************/
set nocount on

select 'AGREGA A "GRUPOASOCIART\IT_BaseDatos" Y A "GRUPOASOCIART\srv_sqlserver" COMO SYSADMIN Y QUITA EL ACCESO A "ADMINISTRATORS" LOCAL'
exec master.dbo.sp_grantlogin        'GRUPOASOCIART\IT_BaseDatos'
exec master.dbo.sp_addsrvrolemember  'GRUPOASOCIART\IT_BaseDatos',		sysadmin
exec master.dbo.sp_grantlogin        'GRUPOASOCIART\srv_sqlserver'
exec master.dbo.sp_addsrvrolemember  'GRUPOASOCIART\srv_sqlserver',	sysadmin
exec master.dbo.sp_revokelogin       'BUILTIN\Administrators'

select 'LISTADO DE LOGINS'
select substring(name,1,32) as 'Login', (case sysadmin when 0 then 'NO' when 1 then 'SI' end) as 'SysAdmin' from master..syslogins order by name

go

/************************************************************
   Pone la base de datos Model en Recovery Mode 'Simple'
************************************************************/
set nocount on

select 'PONE LA BASE DE DATOS MODEL EN RECOVERY MODE "SIMPLE"'
alter database model set recovery simple

select 'OPCIONES HABILITADAS DE LA BASE DE DATOS MODEL'
exec master..sp_dboption 'model'

go


/************************************************************
   Agrega los roles standard a la base de datos Model
************************************************************/
use model
go
set nocount on

select 'AGREGA LOS ROLES STANDARD A LA BASE DE DATOS MODEL'
if not exists (select * from sysusers where name = 'Role_Ejecucion')    exec dbo.sp_addrole 'Role_Ejecucion'
if not exists (select * from sysusers where name = 'Role_Consulta')     exec dbo.sp_addrole 'Role_Consulta'
if not exists (select * from sysusers where name = 'Role_Modificacion') exec dbo.sp_addrole 'Role_Modificacion'
if not exists (select * from sysusers where name = 'Role_Compilacion')  exec dbo.sp_addrole 'Role_Compilacion'
exec dbo.sp_addrolemember 'db_datareader'    , 'Role_Consulta'
exec dbo.sp_addrolemember 'db_datareader'    , 'Role_Modificacion'
exec dbo.sp_addrolemember 'db_datawriter'    , 'Role_Modificacion'
exec dbo.sp_addrolemember 'db_ddladmin'      , 'Role_Compilacion'
exec dbo.sp_addrolemember 'db_securityadmin' , 'Role_Compilacion'

select 'LISTA USUARIOS DE LA BASE DE DATOS MODEL Y LOS ROLES A QUE PERTENECEN'
select substring(u1.name,1,32) as 'Usuario/Role', (case when u2.name is not null then u2.name else '' end) as 'Pertenece a Role'
 from sysusers u1 left join sysmembers m on u1.uid = m.memberuid left join sysusers u2 on m.groupuid = u2.uid
 order by u1.isapprole, u1.issqlrole, u1.name, u2.name
go





/**********************************************
   Crea la base de datos SYSDBA y sus objetos
**********************************************/
use master
go
set nocount on
go
set quoted_identifier off 
go
set ansi_nulls on 
go

select 'CREA LA BASE DE DATOS SYSDBA Y SUS OBJETOS'
if not exists (select name from master.dbo.sysdatabases where name = 'SYSDBA')
  begin
	declare @ubic varchar(255), @create varchar(516)
	select @ubic = left(filename,(len(filename)-10)) from sysdatabases where name = 'master'
	select @create = 'create database [SYSDBA] on (name = ''SYSDBA_Data'', filename = ''' + @ubic + 'SYSDBA_Data.MDF'', size = 80) log on (name = ''SYSDBA_Log'', filename = ''' + @ubic + 'SYSDBA_Log.LDF'', size = 20)'	exec (@create)
  end
go

exec sp_dboption 'SYSDBA', 'autoclose', 'false'
go
exec sp_dboption 'SYSDBA', 'bulkcopy', 'false'
go
exec sp_dboption 'SYSDBA', 'trunc. log', 'true'
go
exec sp_dboption 'SYSDBA', 'torn page detectio', 'true'
go
exec sp_dboption 'SYSDBA', 'read only', 'false'
go
exec sp_dboption 'SYSDBA', 'dbo use', 'false'
go
exec sp_dboption 'SYSDBA', 'single', 'false'
go
exec sp_dboption 'SYSDBA', 'autoshrink', 'false'
go
exec sp_dboption 'SYSDBA', 'ANSI null default', 'false'
go
exec sp_dboption 'SYSDBA', 'recursive triggers', 'false'
go
exec sp_dboption 'SYSDBA', 'ANSI nulls', 'false'
go
exec sp_dboption 'SYSDBA', 'concat null yields null', 'false'
go
exec sp_dboption 'SYSDBA', 'cursor close on commit', 'false'
go
exec sp_dboption 'SYSDBA', 'default to local cursor', 'false'
go
exec sp_dboption 'SYSDBA', 'quoted identifier', 'false'
go
exec sp_dboption 'SYSDBA', 'ANSI warnings', 'false'
go
exec sp_dboption 'SYSDBA', 'auto create statistics', 'true'
go
exec sp_dboption 'SYSDBA', 'auto update statistics', 'true'
go


use SYSDBA
go

if (select suser_sname(sid) from master..sysdatabases where name = 'SYSDBA') <> 'sa'
 exec sp_changedbowner 'sa'
go

if not exists (select name from SYSDBA.dbo.sysobjects where name = 'DB_Spaces')
 create table dbo.DB_Spaces	(
			point		  int identity,
			database_name	  sysname,
			database_size	  dec(15,0) null,
			unallocated_space dec(15,0) null,
			reserved	  dec(15,0) null,
			data		  dec(15,0) null,
			index_size	  dec(15,0) null,
			unused		  dec(15,0) null,
			date		  datetime  null
				)
go


if exists (select name from dbo.sysobjects where name = 'SYSDBA_ABMJobs')
   drop table SYSDBA_ABMJobs
go

create table [dbo].[SYSDBA_ABMJobs] (
	[Id] [int] IDENTITY (1, 1) constraint [PK_SYSDBA_ABMJOBS] primary key clustered ,
	[Fecha_Reg] [datetime] default getdate() ,
	[Servidor] [varchar] (40) ,
	[Job] [varchar] (100) ,
	[Tipo] [varchar] (50) ,
	[Usuario] [varchar] (50) 
)
go


if exists (select name from SYSDBA.dbo.sysobjects where name = 'asigna_permisos_sp')
  drop procedure asigna_permisos_sp
go

create procedure dbo.asigna_permisos_sp
as
set nocount on
declare @databases table (nro int identity, dbname varchar(500))
create table #permisos (nro int identity, permiso varchar(500))
declare @dbname  varchar(500), @cont1 int
declare @permiso varchar(500), @cont2 int
insert @databases(dbname) select '[' + name  + ']' from master..sysdatabases
 where name not in ('master', 'model', 'msdb', 'tempdb', 'northwind', 'pubs', 'distribution', 'distribution1', 'distribution2', 'distribution3', 'SYSDBA', 'system', 'mantenimiento')
  and status in (4, 8, 12, 16, 20, 24, 28, 4194304, 4194308, 4194312, 4194316, 4194320, 4194328, 4194332) order by name desc
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont1
    truncate table #permisos
    select @permiso = 'use ' + @dbname + ' exec ("insert #permisos(permiso) select ''grant exec on ['' + u.name + ''].['' + o.name + ''] to Role_Ejecucion'' from dbo.sysobjects o join dbo.sysusers u on o.uid = u.uid where type = ''P'' order by u.name desc, o.name desc")'
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
go


if exists (select name from SYSDBA.dbo.sysobjects where name = 'asigna_permisos_fn')
  drop procedure asigna_permisos_fn
go

create procedure dbo.asigna_permisos_fn
as
set nocount on
declare @databases table (nro int identity, dbname varchar(500))
create table #permisos (nro int identity, permiso varchar(500))
declare @dbname  varchar(500), @cont1 int
declare @permiso varchar(500), @cont2 int
insert @databases(dbname) select '[' + name  + ']' from master..sysdatabases
 where name not in ('master', 'model', 'msdb', 'tempdb', 'northwind', 'pubs', 'distribution', 'SYSDBA', 'system', 'mantenimiento')
  and status in (4, 8, 12, 16, 20, 24, 28, 4194304, 4194308, 4194312, 4194316, 4194320, 4194328, 4194332) order by name desc
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont1
    truncate table #permisos
    select @permiso = 'use ' + @dbname + ' exec ("insert #permisos(permiso) select ''grant '' + (case type when ''FN'' then ''EXEC'' else ''SELECT'' end) + '' on ['' + u.name + ''].['' + o.name + ''] to '' + (case type when ''FN'' then ''Role_Ejecucion'' else ''Role_Consulta'' end) from dbo.sysobjects o join dbo.sysusers u on o.uid = u.uid where type = ''FN'' or type = ''IF'' or type = ''TF'' order by u.name desc, o.name desc")'
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
go


if exists (select name from SYSDBA.dbo.sysobjects where name = 'permisos')
  drop procedure permisos
go

create procedure dbo.permisos
as
set nocount on
declare @databases table (nro int identity, dbname varchar(500))
declare @comandos  table (nro int identity, comando varchar(8000))
declare @dbname  varchar(500), @cont1 int, @com varchar (8000)
insert @databases(dbname) select '[' + name  + ']' from master..sysdatabases order by name
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont1
    insert @comandos select 'use ' + @dbname + ' select substring(''' + @dbname + '''+ replicate('' '',30-len(''' + @dbname + ''')),1,30) as ''DATABASE'',
(case p.protecttype 
when	204 then ''GRANT_W_GRANT''
when	205 then ''GRANT''
when	206 then ''DENY''
end)		as ''TIPO'',
(case p.action
when	224 then ''EXECUTE''
when	193 then ''SELECT''
when	195 then ''INSERT''
when	196 then ''DELETE''
when	197 then ''UPDATE''
when	26  then ''REFERENCES''
when	203 then ''CREATE DATABASE''
when	198 then ''CREATE TABLE''
when	207 then ''CREATE VIEW''
when	222 then ''CREATE PROCEDURE''
when	178 then ''CREATE FUNCTION''
when	236 then ''CREATE RULE''
when	233 then ''CREATE DEFAULT''
when	228 then ''BACKUP DATABASE''
when	235 then ''BACKUP LOG''
end)		as ''PERMISO'',
''ON''			as ''ON'',
''['' + o.name + '']''	as ''OBJETO'',
''TO''			as ''TO'',
u.name			as ''ROLE/USUARIO''
 into #salida1
 from sysprotects p join sysusers u on p.uid=u.uid join sysobjects o on p.id=o.id
 where not (
	   (p.action = 224 and u.name like ''Role_Ejecucion'')
	or (p.action = 193 and u.name like ''Role_Consulta'')
	or (o.name like ''RTb%'' and u.name like ''public'')
	or (o.name like ''r_iRTb%'' and u.name like ''public'')
	or (OBJECTPROPERTY (o.id, ''IsMSShipped'') = 1 and u.name like ''public'')
	   )
 order by u.name, p.protecttype, p.action, o.name
select  ''['' + u.name + '']'' 	as ''OWNER'',
	''['' + o.name + '']''	as ''OBJETO''
 into #salida2
 from sysusers u join sysobjects o on u.uid=o.uid
 where not (
	   (u.name = ''INFORMATION_SCHEMA'')
	or (u.name = ''system_function_schema'')
	   )
 order by u.name, o.name
select s1.[DATABASE] + s1.[TIPO] + '' '' + s1.[PERMISO] + '' '' + s1.[ON] + '' '' + s2.[OWNER] + ''.'' + s2.[OBJETO] + '' '' + s1.[TO] + '' '' + s1.[ROLE/USUARIO]
 from #salida1 s1 join #salida2 s2 on s1.OBJETO=s2.OBJETO
 order by s1.[ROLE/USUARIO], s2.[OWNER], s2.[OBJETO], s1.[TIPO], s1.[PERMISO]
drop table #salida1
drop table #salida2'
    select @cont1 = @cont1 - 1
  end
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @com = comando from @comandos where nro = @cont1
    exec (@com)
    select @cont1 = @cont1 - 1
  end
go


if exists (select name from SYSDBA.dbo.sysobjects where name = 'perfiles')
  drop procedure perfiles
go

create procedure dbo.perfiles
as
set nocount on
declare @databases table (nro int identity, dbname  varchar(500))
declare @comandos  table (nro int identity, comando varchar(8000))
declare @dbname varchar(500), @cont1 int, @com varchar (8000)
insert @databases(dbname) select '[' + name  + ']' from master..sysdatabases order by name
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @dbname = dbname from @databases where nro = @cont1
    insert @comandos select 'use ' + @dbname + ' select substring(''' + @dbname + '''+ replicate('' '',30-len(''' + @dbname + ''')),1,30) as ''Database'',
							substring(u1.name,1,30) as ''Usuario/Role'',
							substring((case when (u2.name is not null and u1.isaliased = 0) then u2.name
									when (u2.name is null and u1.isaliased <> 0) then ''Alias '' + convert(varchar(9),u1.altuid)
									else '''' end),1,30) as ''Pertenece a Role''
 from sysusers u1 left join sysmembers m on u1.uid = m.memberuid left join sysusers u2 on m.groupuid = u2.uid
 where not (u2.name in (''Role_Ejecucion'', ''Role_Consulta'')                  or
	   (u1.name = ''dbo''               and u2.name = ''db_owner'')         or
	   (u1.name = ''Role_Compilacion''  and u2.name = ''db_ddladmin'')      or
	   (u1.name = ''Role_Compilacion''  and u2.name = ''db_securityadmin'') or
	   (u1.name = ''Role_Consulta''     and u2.name = ''db_datareader'')    or
	   (u1.name = ''Role_Modificacion'' and u2.name = ''db_datareader'')    or
	   (u1.name = ''Role_Modificacion'' and u2.name = ''db_datawriter''))   or
	   (u1.name not in (''Role_Ejecucion''		,''Role_Consulta'',
			    ''Role_Modificacion''	,''Role_Compilacion'',
			    ''db_accessadmin''		,''db_backupoperator'',
			    ''db_datareader''		,''db_datawriter'',
			    ''db_ddladmin''		,''db_denydatareader'',
			    ''db_denydatawriter''	,''db_owner'',
			    ''db_securityadmin''	,''dbo'',
			    ''guest''			,''INFORMATION_SCHEMA'',
			    ''system_function_schema''	,''public'',
			    ''TargetServersRole'')) 			        or
	   (u1.isaliased <> 0)
 order by u1.isapprole, u1.issqlrole, u1.name, u2.name'
    select @cont1 = @cont1 - 1
  end
select @cont1 = max(nro) from @databases
while  @cont1 <> 0
  begin
    select @com = comando from @comandos where nro = @cont1
    exec (@com)
    select @cont1 = @cont1 - 1
  end
go


if exists (select name from SYSDBA.dbo.sysobjects where name = 'db_space')
  drop procedure db_space
go

create procedure dbo.db_space
as
/* calcula es espacio de cada una de las bases de datos del server */
set nocount on
declare @pages		Bigint
declare @dbname		sysname
declare @dbsize		dec(15,0)
declare @logsize	dec(15,0)
declare @bytesperpage	dec(15,0)
declare @pagespermb	dec(15,0)
declare @aux		varchar(30)
declare @cmd		varchar(255)
declare @reserv		dec(15,0)
create table #spt_spaces
 (
 rows		Bigint null,
 reserved	dec(15) null,
 data		dec(15) null,
 indexp		dec(15) null,
 unused		dec(15) null
 )
create table #pivot
 (
 val		dec(15) null,
 )
declare basecursor cursor for select name from master.dbo.sysdatabases where status in (4, 8, 12, 16, 20, 24, 28, 1024, 1028, 1032, 1036, 1040, 1044, 1048, 1052, 4194304, 4194308, 4194312, 4194316, 4194320, 4194328, 4194332, 4195328, 4195332, 4195336, 4195344,4195356) for read only
open basecursor
fetch basecursor into @aux
 while @@fetch_status = 0
  begin
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),size)) from dbo.sysfiles where (status & 64 = 0)")'
	 insert #pivot exec (@cmd)
	 select @dbsize = val from #pivot
	 truncate table #pivot
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),size)) from dbo.sysfiles where (status & 64 <> 0)")'
	 insert #pivot exec (@cmd)
	 select @logsize = val from #pivot
	 truncate table #pivot
	 select @cmd = 'use ' + @aux +  ' exec ("select low from master.dbo.spt_values where number = 1 and type = ''e''")'
	 insert #pivot exec (@cmd)
	 select @bytesperpage = val from #pivot
	 truncate table #pivot
	 select @pagespermb = 1048576 / @bytesperpage
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),reserved)) from sysindexes where indid in (0, 1, 255)")'
	 insert #pivot exec (@cmd)
	 select @reserv = val from #pivot
	 truncate table #pivot
	 insert SYSDBA.dbo.DB_Spaces (database_name , database_size , unallocated_space)
	 select  @aux, ltrim(str((@dbsize + @logsize) / @pagespermb,15,2)), ltrim(str((@dbsize - (@reserv)) / @pagespermb,15,2))
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),reserved)) from sysindexes where indid in (0, 1, 255)")'
	 insert into #spt_spaces (reserved) exec (@cmd)
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),dpages)) from sysindexes where indid < 2")'
	 insert #pivot exec (@cmd)
	 select @pages = val from #pivot
	 truncate table #pivot
	 select @cmd = 'use ' + @aux +  ' exec ("select isnull(sum(convert(dec(15),used)), 0) from sysindexes where indid = 255")'
	 insert #pivot exec (@cmd)
	 select @pages = @pages + val from #pivot
	 truncate table #pivot
	 update #spt_spaces set data = @pages
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),used)) from sysindexes where indid in (0, 1, 255)")'
	 insert #pivot exec (@cmd)
	 select @reserv = val from #pivot
	 truncate table #pivot
	 update #spt_spaces set indexp = @reserv - data
	 select @cmd = 'use ' + @aux +  ' exec ("select sum(convert(dec(15),used)) from sysindexes where indid in (0, 1, 255)")'
	 insert #pivot exec (@cmd)
	 select @reserv = val from #pivot
	 truncate table #pivot
	 update #spt_spaces set unused = reserved - @reserv
	 select  @reserv = ltrim(str(reserved * d.low / 1024.,15,0)),
	  @dbsize = ltrim(str(data * d.low / 1024.,15,0)),
	  @logsize = ltrim(str(indexp * d.low / 1024.,15,0)),
	  @pages = ltrim(str(unused * d.low / 1024.,15,0))
	  from #spt_spaces, master.dbo.spt_values d
	  where d.number = 1 and d.type = 'e'
	 update SYSDBA.dbo.DB_Spaces
	 set  reserved = @reserv, 
	  data = @dbsize, 
	  index_size = @logsize, 
	  unused = @pages,
	  date = getdate()
	 where database_name = @aux and 
	  point = (select max(point) from SYSDBA.dbo.DB_Spaces)
	 truncate table #spt_spaces
	 fetch basecursor into @aux
  end
close basecursor
deallocate basecursor
go


use SYSDBA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[script_seguridad]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[script_seguridad]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_backup_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_backup_log]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_genera_login]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_genera_login]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_hexadecimal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_hexadecimal]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_reindex_dinamico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_reindex_dinamico]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_script_dbroles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_script_dbroles]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_script_logins]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_script_logins]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_seg_usuarios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_seg_usuarios]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
SET ANSI_WARNINGS OFF
GO


CREATE procedure dbo.script_seguridad
as

/*
	Stored principal para la generación de un script que abarca toda la seguridad del server local
	(no incluye seguridad de linked/remote servers)
	Este llama a los submódulos que scriptean cada rama de la seguridad del server
*/

set nocount on 
set ansi_warnings off

execute SYSDBA.dbo.sp_script_dbroles
print ''
print '----------------------------------------------------------------------------------------------------------------------'
print ''
execute SYSDBA.dbo.sp_script_logins



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[sp_backup_log]
@base varchar(2000),			
@ruta varchar(2000),
@cdias int	
as
/*
Parámetros:

	[@base]:	nombre de la base de datos a backupear el log (no puede estar en blanco)
	[@ruta]:	path completo del destino del backup de log (sin incluir el nombre del archivo)
	[@cdias]:	cantidad de días que deben retenerse los archivos de backup de log (debe ser >= 1)

    Version  25-10-2007
*/

EXEC master..xp_subdirs @ruta
if @cdias > 0 
begin
	if exists (select name from master.dbo.sysdatabases where name = @base)
	Begin
		set nocount on
			declare @nombre varchar(2000),
				@nombre2 varchar(2000),
				@ejecutar varchar(2000),
				@archivo varchar(2000),
				@ano varchar(2000),
				@dia varchar(2000),
				@mes varchar(2000),
				@hora varchar(2000),
				@minuto varchar(2000),
				@segundo varchar(2000),
				@tiempo varchar(2000),
				@tiempo2 varchar(2000),
				@FechaActual datetime,
				@ext varchar(2000),  
				@Ruta1 varchar(2000)

			Select @cdias = @cdias * -1
			Select @FechaActual = getdate()
			select @archivo = Rtrim(@base) + '_tlog_'
			select @ext = '.trn'

			select @ano = 
				    case len(cast(datepart(year, @FechaActual) as varchar(4)))
                                    when 1 then '200'+ cast(datepart(year, @FechaActual) as varchar(4))
                                    when 2 then '20' + cast(datepart(year, @FechaActual) as varchar(4))
                                    when 4 then  cast(datepart(year, @FechaActual) as varchar(4))
				    end
			select @mes = 
				    case len(cast(datepart(month, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(month, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(month, @FechaActual) as varchar(2))
				    end
			select @dia = 
                        	    case len(cast(datepart(day, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(day, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(day, @FechaActual) as varchar(2))
                        	    end
			select @hora = 
                        	    case len(cast(datepart(hour, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(hour, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(hour, @FechaActual) as varchar(2))
                        	    end
			select @minuto = 
			            case len(cast(datepart(minute, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(minute, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(minute, @FechaActual) as varchar(2))
				    end
			select @segundo = 
			            case len(cast(datepart(second, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(second, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(second, @FechaActual) as varchar(2))
				    end

			select @tiempo = @ano + @mes + @dia + @hora + @minuto + @segundo
			select @nombre = @ruta + @archivo + @tiempo + @ext

			Select @FechaActual = DATEADD(day, @cdias, @FechaActual)

			select @ano = 
				    case len(cast(datepart(year, @FechaActual) as varchar(4)))
                                    when 1 then '200'+ cast(datepart(year, @FechaActual) as varchar(4))
                                    when 2 then '20' + cast(datepart(year, @FechaActual) as varchar(4))
                                    when 4 then  cast(datepart(year, @FechaActual) as varchar(4))
				    end
			select @mes = 
				    case len(cast(datepart(month, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(month, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(month, @FechaActual) as varchar(2))
				    end
			select @dia = 
                        	    case len(cast(datepart(day, @FechaActual) as varchar(2)))
                                    when 1 then '0'+ cast(datepart(day, @FechaActual) as varchar(2))
                                    when 2 then cast(datepart(day, @FechaActual) as varchar(2))
                        	    end

			select @tiempo2 = @ano + @mes + @dia + @hora + @minuto + @segundo
			select @nombre2 = @archivo + @tiempo2 + @ext
	
			-- realiza el Backup de Log
			backup log @base to disk = @nombre
			
			create table #temp_db (id int identity, archivos varchar(250))
			create table #temp_db2 (id int identity, archivos varchar(250))
		
		Select @Ruta1 = 'master.dbo.xp_cmdshell ''dir '+ @ruta + '*.trn'''

	--	Codigo Modificado 25-10-2007
		-- Inserta los archivos TRN de la carpeta de Backup de log
		insert into #temp_db exec(@Ruta1)

		-- Establece la pocicion del nombre de los archivos TRN en la salida del Dir
		Declare @archivos varchar(300)
		Declare @Posicion smallint
		Select @archivos = archivos from #temp_db where id = 6
		Set @Posicion = patindex('%'+ @base + '%',@archivos)

		-- Inserta la Linas lineas del dir con archivos TRN que deben eliminarse
		-- Tambien le agrega la instruccion de Delete
		Insert into #temp_db2 select 'exec master.dbo.xp_cmdshell ''del '+ @ruta + substring(archivos,@Posicion,len(archivos))+'''' from #temp_db where (substring(archivos,@Posicion,len(archivos)) like @base +'%') and (substring(archivos,@Posicion,len(archivos))<@nombre2)
	--	Codigo Modificado 25-10-2007

		declare @x int
		select @x=1
			while @x < ((select count(*) from #temp_db2)+1)
				begin 
					select @ejecutar = archivos from  #temp_db2 where id = @x
					-- Elimina de a 1 archivo viejo
					exec(@ejecutar)
					select @x=@x+1
				end
			drop table #temp_db
			drop table #temp_db2
		end

	else
	begin 
		print '(BASE INEXISTENTE!!!!!) Sintaxis correcta: Exec dbo.sp_backup_log [BASE],[RUTA BACKUP],[CANTIDAD DIAS DE RETENCION]'
	end
end 
else
	begin	
		print '(EL NUMERO DE RETENCION DEBE SER IGUAL O MAYOR A 1...) Sintaxis correcta: Exec dbo.sp_backup_log [BASE],[RUTA BACKUP],[CANTIDAD DIAS DE RETENCION]'
	end


GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE dbo.sp_genera_login 
	@pass sysname OUTPUT, 
	@defleng varchar(8000) OUTPUT,
	@defdata varchar(8000) OUTPUT,
	@status  integer OUTPUT,
	@SID varchar(8000) OUTPUT,
	@login_name sysname
AS	

/*
	Stored que devuelve los datos completos de un login (incluyendo su password si es de SQL)
	o de un role de base de datos
	Este llama al submódulo que devuelve la password de los logins de SQL Server
*/


DECLARE @name    sysname
DECLARE @xstatus int
DECLARE @binpwd  varbinary (256)
DECLARE @txtpwd  sysname
DECLARE @tmpstr  varchar (8000)
DECLARE @SID_varbinary varbinary(85)
DECLARE @SID_string varchar(256)

SELECT 	@SID_varbinary = sid, 
	@name = name, 
	@xstatus = xstatus, 
	@binpwd = password 
FROM master..sysxlogins 
WHERE 	srvid IS NULL AND 
	name = @login_name

SELECT 	@defdata = (select name from master.dbo.sysdatabases D where D.dbid = S.dbid),
	@defleng = language  
FROM master..sysxlogins S
WHERE 	srvid IS NULL AND 
	name = @login_name

SET @status = 0

IF (@xstatus & 4) = 4
    BEGIN -- NT authenticated account/group
      IF (@xstatus & 1) = 1
      BEGIN -- NT login is denied access
        SET @status = 1
      END
      ELSE BEGIN -- NT login has access
        SET @status = 0
      END
      EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT
      select @SID = @SID_string
    END
    ELSE BEGIN -- SQL Server authentication
      IF (@binpwd IS NOT NULL)
      BEGIN -- Non-null password
	EXEC sp_hexadecimal @binpwd, @txtpwd OUT
        IF (@xstatus & 2048) = 2048
	begin
	  PRINT 'CASO RARO, VER A QUE SE DEBE'
	   -- SET @pass = CONVERT (varchar(256), @txtpwd )
	end
        ELSE
          begin
	  SET @pass = CONVERT (varbinary(256), @txtpwd )
	  end
	EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT
      END
      ELSE BEGIN 
        -- Null password
	EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT
	SET @pass = NULL
      END
    set @SID = @SID_string
    END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE dbo.sp_hexadecimal
    @binvalue varbinary(256),
    @hexvalue varchar(256) OUTPUT
AS

/*
	Stored que devuelve la password de los logins de SQL Server
*/

DECLARE @charvalue varchar(256)
DECLARE @i int
DECLARE @length int
DECLARE @hexstring char(16)
SELECT @charvalue = '0x'
SELECT @i = 1
SELECT @length = DATALENGTH (@binvalue)
SELECT @hexstring = '0123456789ABCDEF' 
WHILE (@i <= @length) 
BEGIN
  DECLARE @tempint int
  DECLARE @firstint int
  DECLARE @secondint int
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +
    SUBSTRING(@hexstring, @firstint+1, 1) +
    SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END
SELECT @hexvalue = @charvalue



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure [dbo].[sp_reindex_dinamico]
		@base varchar(100),
		@tipo int,
		@tabla varchar(100)
as

/*
Parßmetros:
	[@base]:	nombre de la base de datos a reindexar (no puede estar en blanco)
	[@tipo]:	0:	Reindexa todas las tablas de usuario menos la especificada en [@tabla]
					[@tabla] puede estar o no en blanco; si estß en blanco, reindexa todas las tablas de la base
			3:	Reindexa s=lo la tabla especificada en [@tabla]
					[@tabla] no puede estar en blanco
			1:	Reindexa s=lo la primer  mitad de las tablas de usuario de la base
					[@tabla] debe estar en blanco
			2:	Reindexa s=lo la segunda mitad de las tablas de usuario de la base
					[@tabla] debe estar en blanco

	Importante:	En caso de utilizar el parametro [@tabla] debe enviarse con el siguiente formato: [owner.tabla]

*/

set nocount on
declare @reg_tot int,@reg_1er_mitad int, @reg_2da_mitad int ,@Itemp int, @reg_actual int,@I int,@baset varchar(1000),@cmd varchar(1000),
@variable varchar(100),@id_tabla varchar(100) , @Peso_total int , @PesoAcumulado int, @Peso int


             --=[ Validaciones ]=--

	if not exists(select name from master.dbo.sysdatabases where name = @base)
	begin
  	     print 'Atenci=n: ' + char(13) + space(10) +'NO existe la base de datos!.'
	     return
	end
	if (@tipo <> 0 and @tipo <>1 and @tipo <> 2 and @tipo <> 3)
	begin
  	     print 'Atenci=n: ' + char(13) + space(10) + 'El tipo debe ser:  ' + char(13) + space(26) + '( 0 = Todo excepto 1 tabla )' + char(13) + space(26) + '( 1 = Primer 50% )' + char(13) + space(26) + '( 2 = Segundo 50% )'+ char(13) + space(26) + '( 3 = Por tabla especifica )'
             return
	end
	if (@tipo =3 and @tabla='')
	begin
  	     print 'Atenci=n: ' + char(13) + space(10) + 'Si utiliza el tipo 3 debe especificar la tabla a reindexar'
             return
	end	
	if ( (@tipo =1 or @tipo =2) and @tabla<>'')
	begin
  	     print 'Atenci=n: ' + char(13) + space(10) + 'En los tipos de Indexaci=n 1 o 2, No se debe especificar nombre de Tabla'
             return
	end	
	if (@tipo = 0 or @tipo = 3) and @tabla <> ''

	begin
		-- Divide parametro Tabla en Owner y Nombre de tabla, busca el id de owner para luego buscar tabla para owner correspondiente 
		declare @posicion tinyint 
		declare @owner varchar(20)
		declare @IdDeUsuario varchar(10)
		set @posicion = PATINDEX('%.%',@tabla)
		if @posicion = 0 
		begin			
			print 'Atenci=n: ' + char(13) + space(10) + 'Debe especificar el Owner en el parßmetro Tabla'
			return
		end

		set @owner = SUBSTRING(@tabla,0,@posicion)
		set @tabla = SUBSTRING(@tabla,@posicion+1,100)
		set @variable = 'select uid from  ' + @base + '.dbo.sysusers where rtrim(ltrim(name)) = ' + '''' +  @owner + '''' 
		
		Create Table #resu ([id_owner] int  NULL)
		insert into #resu exec(@variable)
		set @IdDeUsuario   = (select id_owner from #resu)
		drop table #resu 		
		
		if @IdDeUsuario IS NULL 
		begin			
			print 'Atenci=n: ' + char(13) + space(10) + 'El Owner de la Tabla a indicada no existe'
			return
		end

		Create Table #resultado ([id_tabla] int  NULL)

		-- Busca Tabla para el Owner especificado
		set @variable = 'select id from ' + @base + '.dbo.sysobjects where name = ' + '''' +  @tabla + ''' ' + 'and uid = ' +  @IdDeUsuario + ' and xtype = ' + '''U'''

		insert into #resultado exec(@variable)
 		set @id_tabla  = (select id_tabla from #resultado)
		drop table #resultado 		
	
		if @id_tabla IS NULL 
			begin
				if @tipo = 0
  			 	        	begin
					print 'Atenci=n: ' + char(13) + space(10) + 'La Tabla a excluir no existe'
	             				return
					end
				if @tipo = 3
  		 		        	begin
					print 'Atenci=n: ' + char(13) + space(10) + 'La Tabla a indexar no existe'
	             				return
				       	end
			end
	end
              --=[ Fin Validaciones ]=--

	create table #tobjetos0 ([rows] int,id int)
	create table #tobjetos1 (cmd varchar(1000),[rows] int,tid int identity)
	create table #tobjetos2 (cmd varchar(1000),[rows] int,tid int identity)

	--- Carga los tama±os de paginas sumarizadas por tabla a un Temporario
	if  @tabla <> '' and (@tipo = 0 or @tipo = 3)
		begin
		--excluye la tabla que no hay que indexar en caso de estar el parametro
		if @tipo = 0
			begin
			set @baset = 'insert #tobjetos0 select sum(dpages) as rows, id from ' + @base + '.dbo.sysindexes where id <> ' + @id_tabla + ' group by id'
			end
		if @tipo = 3		
		--incluye solo la tabla que no hay que indexar en caso de estar el parametro
			begin
			set @baset = 'insert #tobjetos0 select sum(dpages) as rows, id from ' + @base + '.dbo.sysindexes where id = ' +  @id_tabla + ' group by id'
			end
		end
	Else
		begin
		set @baset = 'insert #tobjetos0 select sum(dpages) as rows, id from ' + @base + '.dbo.sysindexes group by id'
		end	


	insert #tobjetos0
	exec(@baset)	

	--Genera Sentencias DBCC Reindex
--	set @baset = 'use ' + @base +  ' select ''DBCC DBREINDEX ([' + @base + '.'' + user_name(uid) + ''.''+ '+ @base +'.dbo.sysobjects.name + '']''+'','''''''',0)'' as comand, [rows] from '+ @base +'.dbo.sysobjects join '+ @base +'.dbo.#tobjetos0 on ('+ @base +'.dbo.sysobjects.id='+ @base +'.dbo.#tobjetos0.id)  where xtype=''U''' + ' order by 2 desc'
	set @baset = 'use ' + @base +  ' select ''DBCC DBREINDEX ([' + @base + '.'' + user_name(uid) + ''.''+ '+ @base +'.dbo.sysobjects.name + '']''+'','''''''',0)'' as comand, [rows] from '+ @base +'.dbo.sysobjects join #tobjetos0 on ('+ @base +'.dbo.sysobjects.id=#tobjetos0.id)  where xtype=''U''' + ' order by 2 desc'

	insert into #tobjetos1
	exec(@baset)	

	drop table #tobjetos0

	select @reg_tot = count(*) from #tobjetos1
	select @reg_1er_mitad = (@reg_tot / 2)
	select @reg_2da_mitad = (@reg_tot - @reg_1er_mitad)
	print 'Comienzo  ' + cast(getdate() as varchar(40))
	print 'Total Tablas de Usuario   ' +  cast(@reg_tot as varchar(40))
	print ''	

	--procesa o una todos los registros de la base

	if (@tipo = 0 or @tipo = 3)  
	 begin
		print 'Inicio de procesamiento'
		print '--------------------------------------------------------------'
		set @I=1
		while @I<= (select count(*) from #tobjetos1)
		begin
       			select @cmd = cmd from #tobjetos1 where tid = @I
			select @Peso = [rows] from #tobjetos1 where tid = @I
			print @cmd			exec (@cmd)
			print cast(getdate() AS char(30)) + ' Peso: ' +  cast(@Peso AS char(10))
			set @I = @I + 1
		end
		goto finalizar
	 end


	/******************************************************/
	/*   particiona la tabla en #tobjetos1 y #tobjetos2   */
	/******************************************************/
	-- Modificacion 06-2007 Se controla Tamaño de Division de Tablas
	select @Peso_total = sum([rows]) from #tobjetos1
	select @PesoAcumulado = 0
	-- Modificacion 06-2007
	select @reg_actual = 1	
	select @I = 1
	while @I < = @reg_1er_mitad 
	 begin
		-- Modificacion 06-2007 Se controla Tamaño de Division de Tablas
		select @Peso = [rows] from  #tobjetos1 where tid = @reg_actual
		-- Modificacion 06-2007	

		insert #tobjetos2
		select cmd,[rows] from  #tobjetos1 where tid = @reg_actual
		delete #tobjetos1 where tid = @reg_actual
		select @reg_actual = @reg_actual + 2
		select @I = @I + 1

		-- Modificacion 06-2007 Se controla Tamaño de Division de Tablas
		select @PesoAcumulado = @PesoAcumulado + @Peso	
		if @PesoAcumulado >= @Peso_total/2
			break
		else
		        Continue
		-- Modificacion 06-2007
	 end 
	/*********************************************************/
	/*  Fin  particiona la tabla en #tobjetos1 y #tobjetos2  */
	/*********************************************************/


	--procesa la primer mitad seleccionado 1	

	if (@tipo = 1)
	 begin
		print 'Inicio de procesamiento del 1er 50% de los objetos'
		print '--------------------------------------------------------------'
		set @I=1
		set @reg_actual = 2
		while @I<= (select count(*) from #tobjetos1)
		begin
       			select @cmd = cmd from #tobjetos1 where tid=@reg_actual
			select @Peso = [rows] from #tobjetos1 where tid = @reg_actual
			print  @cmd							begin
				if @cmd<>'' 
				exec (@cmd)
				print cast(getdate() AS char(30)) + ' Peso: ' +  cast(@Peso AS char(10))				end
			set @I = @I + 1
			set @reg_actual = @reg_actual + 2
  	        end	
 		goto finalizar
	end

	--procesa la segunda mitad seleccionado 2
	if (@tipo = 2)
	 begin
		print 'Inicio de procesamiento del 2do 50% de los objetos'
		print '--------------------------------------------------------------'
		set @I=1
		while @I<= (select count(*) from #tobjetos2)
		   begin
       			select @cmd = cmd from #tobjetos2 where tid = @I
			select @Peso = [rows] from #tobjetos2 where tid = @I
			print  @cmd
				begin
				if @cmd<>'' 
				exec (@cmd)
				print cast(getdate() AS char(30)) + ' Peso: ' +  cast(@Peso AS char(10))				end
			set @I = @I + 1
		   end	
		 goto finalizar
	 end

finalizar:
drop table #tobjetos1
drop table #tobjetos2
print '--------------------------------------------------------------'
print 'Fin  ' + cast(getdate() as varchar(40))
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO





SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



CREATE procedure dbo.sp_script_dbroles
as

/*
	Stored que scriptea todo lo relativo a la seguridad de los roles de bases de datos
*/

set nocount on 
set ansi_warnings off

declare @rolename   	sysname
declare @roleid		smallint
declare @isapprole 	int
declare @DBAse  	varchar(255)
declare @cmd1   	nvarchar(255)
declare @contdb 	int

create table #tmp_dbs (id int identity, dbname varchar(255))
create table #tmp_alldbroles (id int identity, rlname varchar(255))
insert #tmp_dbs select name from master..sysdatabases order by name desc
select @contdb = max(id) from #tmp_dbs
while @contdb <> 0
begin
	select @DBAse = dbname from #tmp_dbs where id = @contdb
	create table #tmp_roles (rolename sysname, roleid smallint, isapprole int)
	select @cmd1 = 'execute ' + @DBAse + '.dbo.sp_helprole'
	insert #tmp_roles exec (@cmd1)
	declare allroles cursor for select rolename, roleid, isapprole from #tmp_roles
	open allroles
	fetch next from allroles into @rolename, @roleid, @isapprole
	while (@@fetch_status = 0)
	begin
		if @isapprole = 0
		begin
			if (@roleid >= 16400) and (@rolename not in ('TargetServersRole', 'RepositoryUser'))
			begin
				insert #tmp_alldbroles values (@rolename)
				select @cmd1 = 'execute ' + @DBAse + '.dbo.sp_addrole ''' + @rolename + ''''
				print @cmd1 
			end
		end
		else
		begin
			insert #tmp_alldbroles values (@rolename)
			declare @password varbinary(256)
			select @cmd1 = 'select @password = password from ' + @DBAse + '.dbo.sysusers where uid = ' + convert(varchar(255),@roleid) + ''
			exec sp_executesql @cmd1, N'@password varbinary(256) out', @password out
			print 'execute master.dbo.sp_configure ''allow updates'', 1'
			print 'reconfigure with override'
			print 'go'
			print 'insert ' + @DBAse + '.dbo.sysusers values (' + convert(varchar(255),@roleid) + ', 32, ''' + @rolename + ''', NULL, 0x00, getdate(), getdate(), 1, convert(varbinary(256),'
			print @password
			print '))'
			print 'go'
			print 'execute master.dbo.sp_configure ''allow updates'', 0'
			print 'reconfigure with override'
			print 'go'
			print '----------------------------------------------------------------------------------------------------------------------'
		end
		fetch next from allroles into @rolename, @roleid, @isapprole
	end
	close allroles
	deallocate allroles

	create table #tmp_member_roles (DbRole sysname, MemberName sysname, MemberSID varbinary(85))
	declare allroles cursor for select rolename, roleid, isapprole from #tmp_roles
	open allroles
	fetch next from allroles into @rolename, @roleid, @isapprole
	while (@@fetch_status = 0)
	begin
		if @isapprole = 0 and @rolename <> 'public'
		begin
			select @cmd1 = 'execute ' + @DBAse + '.dbo.sp_helprolemember ''' + @rolename + ''''
			insert #tmp_member_roles exec (@cmd1)
			declare addrolemember cursor for select DbRole, MemberName from #tmp_member_roles where MemberSID is null
			declare @dbrole sysname, @membername sysname
			open addrolemember
			fetch next from addrolemember into @dbrole, @membername
			while (@@fetch_status = 0)
			begin
				print 'execute ' + @DBAse + '.dbo.sp_addrolemember ''' + @dbrole + ''', ''' + @membername + ''''
				fetch next from addrolemember into @dbrole, @membername
			end
			close addrolemember
			deallocate addrolemember
			truncate table #tmp_member_roles
		end
		fetch next from allroles into @rolename, @roleid, @isapprole
	end
	close allroles
	deallocate allroles
	drop table #tmp_member_roles
	drop table #tmp_roles 
	print '----------------------------------------------------------------------------------------------------------------------'
	select @contdb = @contdb - 1
end

-- IMPRIME COMANDOS GENERADOS PARA LOS PERMISOS DE LOS ROLES SOBRE OBJETOS Y BASES DE DATOS ----------------------
insert #tmp_alldbroles values('public')
declare @rlname varchar(255)
declare alldbroles cursor for select distinct rlname from #tmp_alldbroles order by rlname
open alldbroles
fetch next from alldbroles into @rlname
while (@@fetch_status = 0)
begin
	exec DBA.dbo.sp_seg_usuarios @rlname
	fetch next from alldbroles into @rlname
end
close alldbroles
deallocate alldbroles
drop table #tmp_alldbroles



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




CREATE procedure dbo.sp_script_logins
as

/*
	Stored que scriptea todo lo relativo a la seguridad de los logins de SQL Server y cuentas de Windows
*/

set nocount on 
set ansi_warnings off

declare @contlg	    int
declare	@indx	    int 
declare	@db	    nvarchar(4000)
declare @cmd	    nvarchar(4000)
declare @cmduser    nvarchar(4000)
declare @dbuser     nvarchar(4000)
declare @olduser    varchar(8000)
declare @login_name sysname
declare @pass	    sysname
declare @defleng    varchar(8000)
declare @defdata    varchar(8000)
declare @status     integer	-- '0': grant; '1': deny
declare @sid        varchar(8000)

if exists (select * from SYSDBA.dbo.sysobjects where name = 'logins' and type = 'U') drop table SYSDBA.dbo.logins
create table SYSDBA.dbo.logins (id int identity, sid varbinary (255), login sysname)
insert SYSDBA.dbo.logins select sid, name from master.dbo.syslogins where name not like 'sa' order by name desc
select @contlg = max(id) from SYSDBA.dbo.logins
while @contlg > 0
begin
	select @login_name = login from SYSDBA.dbo.logins where id = @contlg
	select @pass = null, @defdata = null, @defleng = null, @status = null, @sid = null

	exec SYSDBA.dbo.sp_genera_login @pass out, @defleng out, @defdata out, @status out, @sid out, @login_name

---------- CREA TABLA PARA ALMACENAR LOS COMANDOS GENERADOS -----------------------------------------------------------
	create table #tmp_login_rights (id int identity, rights_text char(8000))

	-- SI @login_name CONTIENE '\' ENTONCES ES LOGIN WINDOWS
	select @indx=charindex('\',@login_name)
	if @indx > 0 

---------- GENERA COMANDOS PARA AGREGAR LOGIN WINDOWS -----------------------------------------------------------------
	begin
		insert #tmp_login_rights select 'execute [master].[dbo].[sp_grantlogin] [' + @login_name + ']'
		insert #tmp_login_rights select 'execute [master].[dbo].[sp_defaultdb] [' + @login_name + '],[' + @defdata + ']'
		insert #tmp_login_rights select 'execute [master].[dbo].[sp_defaultlanguage] [' + @login_name + '],[' + @defleng + ']'
		if (@status = 1) insert #tmp_login_rights values('execute [master].[dbo].[sp_denylogin] [' + @login_name + ']')
	end

---------- GENERA COMANDOS PARA AGREGAR LOGIN SQL ---------------------------------------------------------------------
	else
	begin
		insert #tmp_login_rights
		 select 'execute [master].[dbo].[sp_addlogin] [' + @login_name + '],' + isnull(convert(varchar(8000),@pass), '''''') + ',[' + @defdata + '],[' + @defleng + '], ' + @sid + ', [skip_encryption]' 
	end

---------- GENERA COMANDOS PARA AGREGAR LOGIN A SERVER ROLES ----------------------------------------------------------
	create table #tmpsrvroles (
				serverrole varchar(3000),
				membername varchar(3000),
				membersid  varbinary(85)
				   )
	set @cmd = '[master].[dbo].[sp_helpsrvrolemember]'
	insert #tmpsrvroles exec (@cmd)
	insert #tmp_login_rights
	 select 'execute [master].[dbo].[sp_addsrvrolemember] ' + '[' + rtrim(@login_name) + ']' + ',[' + rtrim(a.serverrole) + ']' as rights_text         
	  from #tmpsrvroles a where a.membername = @login_name 
	drop table #tmpsrvroles

---------- GENERA COMANDOS PARA AGREGAR LOGIN COMO ALIAS EN BASES DE DATOS --------------------------------------------
	create table #tmp_dbs (id int identity, dbname varchar(255))
	declare @user   varchar(255)
	declare @DBAse  varchar(255)
	declare @alias  varchar(255)
	declare @cmd1   varchar(255)
	declare @contdb int
	declare @contus int
	insert #tmp_dbs select name from master..sysdatabases order by name desc
	select @contdb = max(id) from #tmp_dbs
	while @contdb <> 0
	begin
		create table #tmp_users_aliased (id int identity, username varchar(255), alias varchar(255))
		select @DBAse = dbname from #tmp_dbs where id = @contdb
		select @cmd1 = 'insert #tmp_users_aliased select name, altuid from ' + @DBAse + '..sysusers where isaliased = 1 and name = ''\' + @login_name + ''''
		exec (@cmd1)
		select @contus = max(id) from #tmp_users_aliased
		if @contus <> 0
			while @contus <> 0
			begin
				select @user = username, @alias = alias from #tmp_users_aliased where id = @contus
				select @alias = name from..sysusers where uid = @alias
				insert #tmp_login_rights select 'execute [' + @DBAse + '].[dbo].[sp_addalias] [' + substring(@user,2,255) + '], [' + @alias + ']'
				select @contus = @contus - 1
				delete #tmp_dbs where dbname = @DBAse
			end
		drop table #tmp_users_aliased
		select @contdb = @contdb - 1
	end

---------- GENERA COMANDOS PARA AGREGAR LOGIN A BASES DE DATOS --------------------------------------------------------
	declare alldatabases cursor for select dbname from #tmp_dbs
	open alldatabases
	fetch next from alldatabases into @db
	create table #tmpusers (
				username  sysname null,
				groupname sysname null,
				loginname sysname null,
				defdbname sysname null,
				userid    smallint null,
				suserid   smallint null
				)
	while (@@fetch_status = 0)
	begin
		 select @cmduser = 'select @dbuser = name from [' + @db + '].[dbo].[sysusers] where status <> 12 and sid = ' + @sid
		 select @dbuser = ''
		 exec sp_executesql @cmduser, N'@dbuser nvarchar(4000) out', @dbuser out
		 if @dbuser <> ''
		 begin
			 set @cmd = '[' + @db + ']' + '.[dbo].[sp_helpuser] ''' + @dbuser + ''''
			 insert #tmpusers exec (@cmd)
			 insert #tmp_login_rights
			  select 'execute [' + @db + '].[dbo].[sp_grantdbaccess] [' + @login_name + '],[' + rtrim(username) + ']' as rights_text
			   from ( select distinct username, loginname from #tmpusers where loginname = @login_name and username <> 'dbo' )a
			 truncate table #tmpusers
		 end
		 fetch next from alldatabases into @db
	end
	close alldatabases
	deallocate alldatabases

---------- GENERA COMANDOS PARA AGREGAR USUARIOS EN ROLES DE BASES DE DATOS -------------------------------------------
	declare alldatabases cursor for select dbname from #tmp_dbs
	open alldatabases
	fetch next from alldatabases into @db
	while (@@fetch_status = 0)
	begin
		 select @cmduser = 'select @dbuser = name from [' + @db + '].[dbo].[sysusers] where status <> 12 and sid = ' + @sid
		 select @dbuser = ''
		 exec sp_executesql @cmduser, N'@dbuser nvarchar(4000) out', @dbuser out
		 if @dbuser <> ''
		 begin
			 set @cmd = '[' + @db + ']' + '.[dbo].[sp_helpuser] ''' + @dbuser + ''''
			 insert #tmpusers exec (@cmd)
			 insert #tmp_login_rights
			  select distinct 'execute [' + @db + '].[dbo].[sp_addrolemember] [' + rtrim(a.groupname) + '],[' + rtrim(username) + ']' as rights_text            
			   from #tmpusers a 
			   where a.loginname = @login_name and a.groupname <> 'public' and a.username <> 'dbo'
			 truncate table #tmpusers
		 end
		 fetch next from alldatabases into @db
	end
	close alldatabases
	deallocate alldatabases
	drop table #tmpusers
	drop table #tmp_dbs

---------- IMPRIME COMANDOS GENERADOS PARA EL LOGIN -------------------------------------------------------------------
	declare commands cursor for select rights_text from #tmp_login_rights order by id
	open commands
	fetch next from commands into @cmd
	while (@@fetch_status = 0)
	begin
		 print @cmd
		 fetch next from commands into @cmd
	end
	close commands
	deallocate commands
	drop table #tmp_login_rights

---------- IMPRIME COMANDOS GENERADOS PARA LOS PERMISOS DEL LOGIN SOBRE OBJETOS Y BASES DE DATOS ----------------------
	exec DBA.dbo.sp_seg_usuarios @login_name

	print ''
	print '----------------------------------------------------------------------------------------------------------------------'
	print ''

	select @contlg = @contlg - 1
end




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




CREATE procedure dbo.sp_seg_usuarios @login_name sysname
as

/*
	Stored que scriptea los permisos sobre objetos de los usuarios y roles de bases de datos
*/

set nocount on 
set ansi_warnings off

declare @cmd	    nvarchar(4000)
declare	@db	    nvarchar(4000)
declare @user       varchar(8000)
declare @cnt        int
declare @check	    int
declare @orden	    int

set @orden = 1

declare alldatabases cursor for select name from [master].[dbo].[sysdatabases] where status in (4, 8, 12, 16, 20, 24, 28, 4194304, 4194308, 4194312, 4194316, 4194320, 4194328, 4194332)

create table #tmp_login_rights (rights_text char(8000), ord int)

create table #tmpprotect (
			  owner		varchar(1000),
			  object	varchar(1000),
			  grantee	varchar(1000),
			  grantor	varchar(1000),
			  protecttype	char(10),
			  action	varchar(1000),
			  columnx	varchar(1000)
			  )

open alldatabases
fetch next from alldatabases into @db
while (@@fetch_status = 0)
begin

-- BUSCA EL USUARIO PARA EL LOGIN EN CURSO
 set @cmd = 'select @user = name from [' + @db + '].[dbo].[sysusers] where isaliased = 0 and sid = (select sid from [master].[dbo].[syslogins] where loginname = ' + 
             char(39) + @login_name + char(39) + ')' 

 exec [master].[dbo].[sp_executesql] @cmd,N'@user char(200) out',@user out

-- POR SI ES UN ROLE O UN APP_ROLE
 if not exists (select sid from [master].[dbo].[syslogins] where loginname = @login_name)
   begin
	set @user = @login_name

   	-- CONTROLA QUE EL ROLE/APPROLE TENGA PERMISOS EN LA BASE
  	set @cmd = 'select distinct @check = uid from [' + @db + '].[dbo].[sysprotects] where uid = 
		(select uid from [' + @db + '].[dbo].[sysusers] where name = ''' + rtrim(@user) + ''')'
	select @check = ''
	exec sp_executesql @cmd, N'@check nvarchar(4000) out', @check out

  	if @check is null
     	 begin
	   set @user = ''
         end
   end
 else
   begin
  -- CONTROLA QUE EL USUARIO TENGA PERMISOS EN LA BASE
  	set @cmd = 'select distinct @check = uid from [' + @db + '].[dbo].[sysprotects] where uid = 
		(select uid from [' + @db + '].[dbo].[sysusers] where sid = 
		(select sid from [master].[dbo].[syslogins] where name = ''' + rtrim(@login_name) + '''))'
		 select @check = ''
		 exec sp_executesql @cmd, N'@check nvarchar(4000) out', @check out
  	if @check = 0
     	 begin
	   set @user = ''
     	 end
  end	

 if @user <> ''
 begin
-- GENERATE COMMAND TO GET OBJECT PERMISSIONS FOR CURRENT DATABASE
  set @cmd = '[' + @db + '].[dbo].[sp_helprotect]'

-- GET OBJECT PERMISSIONS TEMPORARY TABLE
  insert #tmpprotect exec (@cmd)

  delete #tmpprotect where grantee <> @user or owner = 'system_function_schema'
-- DETERMINE IF THERE ARE ANY OBJECT PERMISSIONS FOR @USER
  select @cnt = count(*) from #tmpprotect 

  if @cnt > 0 
   Begin
    insert #tmp_login_rights
	select 'use [' +  @db + ']', @orden
    set @orden = @orden + 1
   End
-- GRANT STATEMENT PERMISSIONS
  insert #tmp_login_rights (rights_text)
   select rights_text = case rtrim(protecttype) when 'grant' then  'Grant ' + upper(action) + ' to [' + rtrim(@user) + ']'
				     else 	                    'Deny ' + upper(action) + ' to [' + rtrim(@user) + ']'
          end
    from #tmpprotect
    where grantee = @user and object = '.'

-- GENERATE COMMANDS TO GRANT/DENY OBJECTS PERMISSIONS FOR REFERENCES, SELECT, UPDATE
  insert #tmp_login_rights (rights_text)
   select rights_text = case rtrim(protecttype) when 'Grant_WGO' then 'GRANT ' + upper(action) + ' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']' + ' WITH GRANT OPTION'
				     when 'Grant' then  'Grant ' + upper(action) + ' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']'
				     else 	         'Deny ' + upper(action) + ' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']'
          end
    from #tmpprotect
    where grantee = @user and object <> '.' and (columnx = '(All+New)' or columnx is NULL or columnx = '(All)')

-- GRANT/DENY COLUMN PERMISSION ON OBJECTS
  insert #tmp_login_rights (rights_text)
   select rights_text = case rtrim(protecttype) when 'Grant_WGO' then 'GRANT ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + ']([' + columnx + '])' + ' to [' + rtrim(@user) + ']' + ' WITH GRANT OPTION'
				     when 'Grant' then  'Grant ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + ']([' + columnx + '])' + ' to [' + rtrim(@user) + ']'
				     else 	         'Deny ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + ']([' + columnx + '])' + ' to [' + rtrim(@user) + ']'
          end
    from #tmpprotect
    where grantee = @user and object <> '.' and columnx <> '(All+New)' and columnx <> '.' and columnx <> '(All)'

-- GRANT/DENY INSERT, DELETE, AND EXECUTE PERMISSION ON OBJECTS
  insert #tmp_login_rights (rights_text)
   select rights_text = case rtrim(protecttype) when 'Grant_WGO' then 'GRANT ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']' + ' WITH GRANT OPTION'
				     when 'Grant' then  'Grant ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']'
				     else 	         'Deny ' + upper(action) +' on [' + @db + '].[' + owner + '].[' + object + '] to [' + rtrim(@user) + ']'
          end
    from #tmpprotect
    where grantee = @user and object <> '.' and action in ('Insert', 'Delete', 'Execute') and (columnx = '.' or columnx is NULL)

 end

-- REMOVE RECORDS FOR TEMPORARY TABLE IN PREPARATION FOR THE NEXT DATABASE TO BE PROCESSES
 truncate table #tmpprotect
 update #tmp_login_rights set ord = @orden where ord is null
 set @orden = @orden + 1
 fetch next from alldatabases into @db
end
declare commands cursor for select rights_text from #tmp_login_rights order by ord asc
open commands
fetch next from commands into @cmd
while (@@fetch_status = 0)
begin
 print @cmd
 fetch next from commands into @cmd
end
close commands
deallocate commands
close alldatabases
deallocate alldatabases


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



use master
go

if exists (select name from master.dbo.sysobjects where name = 'aviso_shutdown')
  drop procedure aviso_shutdown
go

if exists (select name from master.dbo.sysobjects where name = 'sp_who2_SYSDBA')
	drop procedure dbo.sp_who2_SYSDBA
go



create procedure [dbo].[aviso_shutdown]
as
/*
Genera un mensaje de aviso cuando el SQL Server se inicia,
y lo envfa al server D095srtec17, para que este produzca
una alarma de aviso a quien corresponda.
Es un stored de 'startup' y debe estar en la 'master'
*/
declare @command varchar(512), @server varchar(255), @fecha varchar(25), @cmd varchar(250)
select @server = @@servername
create table master.dbo.ErrorLogs ([Archive #] int, [Date] datetime, [Log File Size (Byte)] int)
select @cmd = 'osql -E -S ' + @server + ' -Q "insert master.dbo.ErrorLogs ([Archive #], [Date], [Log File Size (Byte)]) exec master..sp_enumerrorlogs"'
exec master.dbo.xp_cmdshell @cmd
select @fecha = [Date] from master.dbo.ErrorLogs where [Archive #]=1
select @command = 'osql -E -S D095SRTEC17 -Q "EXEC xp_logevent 60000, ''El servicio SQLSERVER fue iniciado en el server ' + @server + '. La fecha y hora de la bajada de servicio fue: ' + @fecha + '.'', warning"'
exec master.dbo.xp_cmdshell @command
drop table master.dbo.ErrorLogs
go

exec sp_procoption N'aviso_shutdown', N'startup', N'true'
go



CREATE PROCEDURE sp_who2_SYSDBA  --- 2006/05/03 10:16
    @loginame     sysname = NULL
as

set nocount on

declare
    @retcode         int

declare
    @sidlow         varbinary(85)
   ,@sidhigh        varbinary(85)
   ,@sid1           varbinary(85)
   ,@spidlow         int
   ,@spidhigh        int

declare
    @charMaxLenLoginName      varchar(6)
   ,@charMaxLenDBName         varchar(6)
   ,@charMaxLenCPUTime        varchar(10)
   ,@charMaxLenDiskIO         varchar(10)
   ,@charMaxLenHostName       varchar(10)
   ,@charMaxLenProgramName    varchar(10)
   ,@charMaxLenLastBatch      varchar(10)
   ,@charMaxLenCommand        varchar(10)

declare
    @charsidlow              varchar(85)
   ,@charsidhigh             varchar(85)
   ,@charspidlow              varchar(11)
   ,@charspidhigh             varchar(11)

--------

select
    @retcode         = 0      -- 0=good ,1=bad.

--------defaults
select @sidlow = convert(varbinary(85), (replicate(char(0), 85)))
select @sidhigh = convert(varbinary(85), (replicate(char(1), 85)))

select
    @spidlow         = 0
   ,@spidhigh        = 32767

--------------------------------------------------------------
IF (@loginame IS     NULL)  --Simple default to all LoginNames.
      GOTO LABEL_17PARM1EDITED

--------

-- select @sid1 = suser_sid(@loginame)
select @sid1 = null
if exists(select * from master.dbo.syslogins where loginname = @loginame)
	select @sid1 = sid from master.dbo.syslogins where loginname = @loginame

IF (@sid1 IS NOT NULL)  --Parm is a recognized login name.
   begin
   select @sidlow  = suser_sid(@loginame)
         ,@sidhigh = suser_sid(@loginame)
   GOTO LABEL_17PARM1EDITED
   end

--------

IF (lower(@loginame) IN ('active'))  --Special action, not sleeping.
   begin
   select @loginame = lower(@loginame)
   GOTO LABEL_17PARM1EDITED
   end

--------

IF (patindex ('%[^0-9]%' , isnull(@loginame,'z')) = 0)  --Is a number.
   begin
   select
             @spidlow   = convert(int, @loginame)
            ,@spidhigh  = convert(int, @loginame)
   GOTO LABEL_17PARM1EDITED
   end

--------

RaisError(15007,-1,-1,@loginame)
select @retcode = 1
GOTO LABEL_86RETURN


LABEL_17PARM1EDITED:


--------------------  Capture consistent sysprocesses.  -------------------

SELECT

  spid
 ,status
 ,sid
 ,hostname
 ,program_name
 ,cmd
 ,cpu
 ,physical_io
 ,blocked = 
	case 
	    when blocked<>spid then blocked	
	    when blocked = spid then null
	end	

 ,dbid
 ,convert(sysname, rtrim(loginame))
        as loginname
 ,spid as 'spid_sort'

 ,  substring( convert(varchar,last_batch,111) ,6  ,5 ) + ' '
  + substring( convert(varchar,last_batch,113) ,13 ,8 )
       as 'last_batch_char'

      INTO    #tb1_sysprocesses
      from master.dbo.sysprocesses (nolock)  
      	--where spid<>blocked
--	Order by cast(spid as int) asc



--------Screen out any rows?

IF (@loginame IN ('active'))
   DELETE #tb1_sysprocesses
         where   lower(status)  = 'sleeping'
         and     upper(cmd)    IN (
                     'AWAITING COMMAND'
                    ,'MIRROR HANDLER'
                    ,'LAZY WRITER'
                    ,'CHECKPOINT SLEEP'
                    ,'RA MANAGER'
                                  )

         and     blocked       = 0



--------Prepare to dynamically optimize column widths.


Select
    @charsidlow     = convert(varchar(85),@sidlow)
   ,@charsidhigh    = convert(varchar(85),@sidhigh)
   ,@charspidlow     = convert(varchar,@spidlow)
   ,@charspidhigh    = convert(varchar,@spidhigh)



SELECT
             @charMaxLenLoginName =
                  convert( varchar
                          ,isnull( max( datalength(loginname)) ,5)
                         )

            ,@charMaxLenDBName    =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),db_name(dbid))))) ,6)
                         )

            ,@charMaxLenCPUTime   =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),cpu)))) ,7)
                         )

            ,@charMaxLenDiskIO    =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),physical_io)))) ,6)
                         )

            ,@charMaxLenCommand  =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),cmd)))) ,7)
                         )

            ,@charMaxLenHostName  =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),hostname)))) ,8)
                         )

            ,@charMaxLenProgramName =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),program_name)))) ,11)
                         )

            ,@charMaxLenLastBatch =
                  convert( varchar
                          ,isnull( max( datalength( rtrim(convert(varchar(128),last_batch_char)))) ,9)
                         )
      from
             #tb1_sysprocesses
      where
--             sid >= @sidlow
--      and    sid <= @sidhigh
--      and
             spid >= @spidlow
      and    spid <= @spidhigh



--------Output the report.


EXECUTE(
'
SET nocount off

SELECT
             SPID          = convert(char(5),spid)

            ,Status        =
                  CASE lower(status)
                     When ''sleeping'' Then lower(status)
                     Else                   upper(status)
                  END

            ,Login         = substring(loginname,1,' + @charMaxLenLoginName + ')

            ,HostName      =
                  CASE hostname
                     When Null  Then ''  .''
                     When '' '' Then ''  .''
                     Else    substring(hostname,1,' + @charMaxLenHostName + ')
                  END

            ,BlkBy         =
                  CASE               isnull(convert(char(5),blocked),''0'')
                     When ''0'' Then ''  .''
                     Else            isnull(convert(char(5),blocked),''0'')
                  END

            ,DBName        = substring(case when dbid = 0 then null when dbid <> 0 then db_name(dbid) end,1,' + @charMaxLenDBName + ')
            ,Command       = substring(cmd,1,' + @charMaxLenCommand + ')

            ,CPUTime       = substring(convert(varchar,cpu),1,' + @charMaxLenCPUTime + ')
            ,DiskIO        = substring(convert(varchar,physical_io),1,' + @charMaxLenDiskIO + ')

            ,LastBatch     = substring(last_batch_char,1,' + @charMaxLenLastBatch + ')

            ,ProgramName   = substring(program_name,1,' + @charMaxLenProgramName + ')
            ,SPID          = convert(char(5),spid)  --Handy extra for right-scrolling users.
      from
             #tb1_sysprocesses  --Usually DB qualification is needed in exec().
      where
             spid >= ' + @charspidlow  + '
      and    spid <= ' + @charspidhigh + '

      -- (Seems always auto sorted.)   
	order by spid_sort

SET nocount on
'
)
/*****AKUNDONE: removed from where-clause in above EXEC sqlstr
             sid >= ' + @charsidlow  + '
      and    sid <= ' + @charsidhigh + '
      and
**************/


LABEL_86RETURN:


if (object_id('tempdb..#tb1_sysprocesses') is not null)
            drop table #tb1_sysprocesses

return @retcode -- sp_who2_SYSDBA

go


/****************************************
   Restart del servicio SQLServerAgent
****************************************/
set nocount on

select 'BAJA EL SERVICIO "SQL SERVER AGENT"'
exec master.dbo.xp_cmdshell 'sc stop sqlserveragent'
waitfor delay '00:00:20'
select 'LEVANTA EL SERVICIO "SQL SERVER AGENT"'
exec master.dbo.xp_cmdshell 'sc start sqlserveragent'
waitfor delay '00:00:20'

select 'ESTADO DEL SERVICIO "SQL SERVER AGENT"'
exec master.dbo.xp_cmdshell 'sc query sqlserveragent'

go



/***********************************************
   Presenta versión instalada de SQL Server
***********************************************/
set nocount on

select 'VERSIÓN INSTALADA DE SQL SERVER'
select @@version

go
