BACKUP LOG [Migracion_CMA] 
TO  DISK = N'G:\migracion_cma_1ejecSesiones.trn' 
WITH NOFORMAT, NOINIT,  NAME = N'Migracion_CMA-Transaction Log  Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO


BACKUP LOG [asdirect_mig] 
TO  DISK = N'G:\asdirect_mig_1ejecSesiones.trn' 
WITH NOFORMAT, NOINIT,  NAME = N'asdirect_mig-Transaction Log  Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO