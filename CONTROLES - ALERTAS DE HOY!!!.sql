/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  *
FROM [SYSDBA].[dbo].[TBL_ProcesosEncolados]
WHERE FECHA > GETDATE() - 1
order by fecha desc, start_time desc, spid desc


