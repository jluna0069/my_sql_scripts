select a.database_name, 
	max(a.database_creation_date) as database_creation_date, 
	max(a.backup_start_date) as backup_start_date, 
	max(a.backup_finish_date) as backup_finish_date,
	datediff(mi, max(a.backup_start_date), max(a.backup_finish_date)) as backup_time
from msdb..backupset a join master..sysdatabases b on a.database_name = b.name
where a.type='D' 
group by a.database_name
order by a.database_name


select c.database_name, 
		c.backup_size, 
		c.database_creation_date, 
		c.backup_start_date, 
		c.backup_finish_date, 
		datediff(mi, c.backup_start_date, c.backup_finish_date) as backup_time
from (
select a.database_name, 
	max(a.backup_start_date) as backup_start_date
from msdb..backupset a join master..sysdatabases b on a.database_name = b.name
where a.type='D'
group by a.database_name)  as d
join msdb..backupset c on 
d.database_name = c.database_name and d.backup_start_date = c.backup_start_date






select * from msdb..backupset