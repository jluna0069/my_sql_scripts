select database_name,backup_start_date,backup_finish_date from msdb..backupset 
where type='d' and backup_start_date > getdate()-1
--and database_name not in(select name from sysdatabases)
order by backup_start_date desc

select * from sysdatabases
where name not in(
select database_name from msdb..backupset 
where type='d' and backup_start_date > getdate()-1)