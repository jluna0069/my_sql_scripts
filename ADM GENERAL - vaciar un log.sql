ALTER DATABASE Symantec_CMDB 
SET RECOVERY Simple

/*Vaciar file de log*/
backup log Symantec_CMDB with TRUNCATE_ONLY

backup log ctc with no_log

use ctc CHECKPOINT


/*achicar file log*/
sp_helpdb Symantec_CMDB

sp_spaceused @updateusage = N'true'

dbcc shrinkfile(2,10000)


ALTER DATABASE Symantec_CMDB 
SET RECOVERY FULL