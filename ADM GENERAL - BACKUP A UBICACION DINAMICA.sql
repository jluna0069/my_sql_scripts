DECLARE @fecha VARCHAR(50)
DECLARE @archivo VARCHAR(50)
DECLARE @archivo_master VARCHAR(50)
DECLARE @archivo_msdb VARCHAR(50)
DECLARE @archivo_model VARCHAR(50)

SET @fecha = CONVERT(VARCHAR(4), YEAR(GETDATE()))+'-'+ CONVERT(VARCHAR(2), MONTH(GETDATE()))+'-'+CONVERT(VARCHAR(2), DAY(GETDATE()))
SET @archivo = 'E:\BackBases\EdesurDB_'+ @fecha +'.bak'
SET @archivo_master	 = 'E:\BackBases\master_'+ @fecha +'.bak'
SET @archivo_msdb	 = 'E:\BackBases\msdb_'+ @fecha +'.bak'
SET @archivo_model	 = 'E:\BackBases\model_'+ @fecha +'.bak'

--ALTER DATABASE EdesurDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP DATABASE EdesurDB TO DISK = @archivo
BACKUP DATABASE master TO DISK = @archivo_master
BACKUP DATABASE msdb TO DISK = @archivo_msdb
BACKUP DATABASE model TO DISK = @archivo_model

--ALTER DATABASE EdesurDB SET MULTI_USER
GO
EXIT