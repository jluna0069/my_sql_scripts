RESTORE LOG [ASDiret_Mig] 
FROM  DISK = N'G:\ASDiret_Mig_1ejecSesiones.trn' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 1
GO

RESTORE LOG [Migracion_CMA] 
FROM  DISK = N'G:\migracion_cma_1ejecSesiones.trn' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 1
GO
