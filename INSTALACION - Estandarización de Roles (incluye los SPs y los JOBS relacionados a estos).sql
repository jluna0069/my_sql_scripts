/************************************************************
   Agrega los roles estándar a la base de datos Model
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

/************************************************************************************************************************
   Agrega los roles estándar a la base de datos de usuario (el ejemplo es para la BD Proyecto_4)
 ************************************************************************************************************************/
use proyecto_4
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


/************************************************************
 Stored Procedures estándar, para asociar al Rol Ejecución 
************************************************************/



/************************************************************************************************************************
 SP para Stored Procedures
 **************************************************************************************************************
 Reemplazar las menciones a la Base de Datos por la que se desea estandarizar
************************************************************************************************************************/

USE [SYSDBA]
GO

/****** Object:  StoredProcedure [dbo].[asigna_permisos_sp_PROYECTO_4]    Script Date: 09/10/2015 11:40:58 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[asigna_permisos_sp_PROYECTO_4]
as
set nocount on

create table #grantsps(id [int] IDENTITY(1,1) NOT NULL, db varchar(500), script varchar(500))
create table #db (db varchar(500))

insert into #db (db)
select name from master.sys.databases where name = 'PROYECTO_4'

declare @dbs varchar(500)
declare @db varchar(500)
declare @script varchar(2000)
declare @id int

while (select count(*) from #db )<> 0

begin

select top 1 @db = db from #db


--select @dbs = 'use ' + @db + ' 
--GO'

select @dbs = 'use ' + @db

set @script = @dbs + ' insert into #grantsps select ''' + @db + ''' ,'' grant exec on ['' + schema_name(o.uid) + ''].['' + o.name + ''] to [Role_Ejecucion]'' 
from dbo.sysobjects o where type = ''P'''

exec(@script)

delete #db where db = @db

end 

--asigno permisos

while (select count(*) from #grantsps) <> 0
begin

select @dbs = 'use ' + @db

select top 1 @id = id, @script = script, @dbs = 'use ' + db from #grantsps

exec(@dbs + ' ' + @script)

delete #grantsps where id = @id

end

drop table #grantsps
drop table #db


GO

/************************************************************************************************************************
 SP para Funciones
 **************************************************************************************************************
 Reemplazar las menciones a la Base de Datos por la que se desea estandarizar
************************************************************************************************************************/


USE [SYSDBA]
GO

/****** Object:  StoredProcedure [dbo].[asigna_permisos_fn_proyecto_4]    Script Date: 09/10/2015 11:41:17 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[asigna_permisos_fn_proyecto_4]
as
set nocount on

create table #grantsps(id [int] IDENTITY(1,1) NOT NULL, db varchar(500), script varchar(500))
create table #db (db varchar(500))

insert into #db (db)
select name from master.sys.databases where name = 'proyecto_4'

declare @dbs varchar(500)
declare @db varchar(500)
declare @script varchar(2000)
declare @id int

while (select count(*) from #db )<> 0

begin

select top 1 @db = db from #db


--select @dbs = 'use ' + @db + ' 
--GO'

select @dbs = 'use ' + @db

set @script = @dbs + ' insert into #grantsps select ''' + @db + ''' ,'' grant exec on ['' + schema_name(o.uid) + ''].['' + o.name + ''] to [Role_Ejecucion]'' 
from dbo.sysobjects o where type = ''FN'''

exec(@script)

delete #db where db = @db

end 

--asigno permisos

while (select count(*) from #grantsps) <> 0
begin

select @dbs = 'use ' + @db

select top 1 @id = id, @script = script, @dbs = 'use ' + db from #grantsps

exec(@dbs + ' ' + @script)

delete #grantsps where id = @id

end


drop table #grantsps
drop table #db



GO

/************************************************************************************************************************
 SP para Vistas
 **************************************************************************************************************
 Reemplazar las menciones a la Base de Datos por la que se desea estandarizar
************************************************************************************************************************/


USE [SYSDBA]
GO

/****** Object:  StoredProcedure [dbo].[asigna_permisos_vd_PROYECTO_4]    Script Date: 09/10/2015 11:41:40 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[asigna_permisos_vd_PROYECTO_4]
as
set nocount on

create table #grantsps(id [int] IDENTITY(1,1) NOT NULL, db varchar(500), script varchar(500))
create table #db (db varchar(500))

insert into #db (db)
select name from master.sys.databases where name = 'PROYECTO_4'

declare @dbs varchar(500)
declare @db varchar(500)
declare @script varchar(2000)
declare @id int

while (select count(*) from #db )<> 0

begin

select top 1 @db = db from #db


--select @dbs = 'use ' + @db + ' 
--GO'

select @dbs = 'use ' + @db

set @script = @dbs + ' insert into #grantsps select ''' + @db + ''' ,'' grant view definition on ['' + schema_name(o.uid) + ''].['' + o.name + ''] to [Role_ViewDefinition]'' 
from dbo.sysobjects o join dbo.sysusers u on o.uid = u.uid where type in (''P'', ''FN'', ''IF'', ''TF'', ''U'', ''V'')'

exec(@script)

delete #db where db = @db

end 

--asigno permisos

while (select count(*) from #grantsps) <> 0
begin

select @dbs = 'use ' + @db

select top 1 @id = id, @script = script, @dbs = 'use ' + db from #grantsps

exec(@dbs + ' ' + @script)

delete #grantsps where id = @id

end

drop table #grantsps
drop table #db





GO




/************************************************************************************************************************
************************************************************************************************************************
Código de los Jobs
****************************************************************************************************************
Reemplazar las menciones a la Base de Datos por la que se desea estandarizar
************************************************************************************************************************
************************************************************************************************************************/


/************************************************************************************************************************
 Job de Stored Procedures
************************************************************************************************************************/

USE [msdb]
GO

/****** Object:  Job [DBA - proyecto_4 - Asigna Permisos Ejecucion de SPS]    Script Date: 09/10/2015 12:04:25 p.m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 09/10/2015 12:04:25 p.m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - proyecto_4 - Asigna Permisos Ejecucion de SPS', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No hay ninguna descripción.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1]    Script Date: 09/10/2015 12:04:26 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec asigna_permisos_sp_proyecto_4', 
		@database_name=N'SYSDBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20120109, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'6912dcd3-315c-499e-9161-0c9f51cc2cc7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


/************************************************************************************************************************
 Job de las Funciones
************************************************************************************************************************/

USE [msdb]
GO

/****** Object:  Job [DBA - proyecto_4 - Asigna Permisos Ejecucion de FNS]    Script Date: 09/10/2015 12:09:48 p.m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 09/10/2015 12:09:48 p.m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - proyecto_4 - Asigna Permisos Ejecucion de FNS', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No hay ninguna descripción.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1]    Script Date: 09/10/2015 12:09:48 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec asigna_permisos_fn_proyecto_4', 
		@database_name=N'SYSDBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20120109, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'8ef42c43-ab3a-4d02-b70b-0b718a8d797b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


/************************************************************************************************************************
 Job de las Vistas
************************************************************************************************************************/


USE [msdb]
GO

/****** Object:  Job [DBA - proyecto_4 - Asigna Permisos de VD]    Script Date: 09/10/2015 12:10:22 p.m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 09/10/2015 12:10:22 p.m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - proyecto_4 - Asigna Permisos de VD', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No hay ninguna descripción.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1]    Script Date: 09/10/2015 12:10:22 p.m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec asigna_permisos_vd_proyecto_4', 
		@database_name=N'SYSDBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20120109, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'0a1318be-ec16-44cb-bb28-ed5f8adc68a4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


