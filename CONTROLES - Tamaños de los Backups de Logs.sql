USE msdb
go
set nocount on
if not exists (select * from msdb..sysobjects where name ='bckp_types' and type ='S')
begin 
create table msdb..bckp_types (num int identity(1,1),type varchar(1),bkp_name varchar(20))
--insert into <dbname>..bckp_types (type,bkp_name) values ('D','Full backup')
insert into msdb..bckp_types (type,bkp_name) values ('L','Log Backup')
--insert into <dbname>..bckp_types (type,bkp_name) values ('F','Filegroup backup')
--insert into <dbname>..bckp_types (type,bkp_name) values ('I','Differential backup')
end 
go

Declare @loop int
select @loop= max(num) from bckp_types
While (@loop !=0)
begin 
Select bkp_name +' history details.' as 'Nombre de Backup' from bckp_types where num=@loop
declare @bk_type varchar(1)
select @bk_type = type from bckp_types where num=@loop

SELECT s.name                     'database Name',
       b.backup_finish_date         'last backup date',
    b.backup_size/1024/1024 'backup size(KB)'
       ,bmf.physical_device_name     'location of backup'
  FROM master..sysdatabases s LEFT OUTER JOIN msdb..backupset b ON s.name = b.database_name
  INNER JOIN msdb..backupmediafamily bmf ON b.media_set_id = bmf.media_set_id
  WHERE s.name not in ('tempdb','master','modal','msdb','distribution')
--  AND b.backup_finish_date = (SELECT MAX(backup_finish_date)
--                              FROM msdb..backupset
--                              WHERE database_name = b.database_name
--                              AND type = @bk_type) 
  
--group by s.name
ORDER BY s.name

set @loop=@loop-1
end
go
Drop table msdb..bckp_types


--------------------------------------------------------------------------------
