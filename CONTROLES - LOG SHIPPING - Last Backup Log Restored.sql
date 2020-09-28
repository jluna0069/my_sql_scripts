SELECT   d.name,
         MAX(b.backup_finish_date) AS backup_finish_date
FROM     master.sys.sysdatabases d
         LEFT OUTER JOIN msdb..backupset b
         ON       b.database_name = d.name
         AND      b.type          = 'L'
GROUP BY d.name
ORDER BY backup_finish_date DESC