USE PISCYS
go
SELECT %%lockres%% as lr,
	   a.[ANEXOIV_Seguimientos]
      ,a.[POLIZA]
      ,a.[CUITCUIL]
      ,a.[Establecimiento]
      ,a.[FECHA_ENVIO]
      ,a.[ESTADO]
  FROM [PISCYS].[dbo].[ANEXOIVSEGIMP] a
  
  
/*
Ubicación física de un registro.
Por ejemplo, el último registro está ubicado en
el FILE 4, en la PÁGINA 5644452, en el SLOT 7
*/

----------------------------------------------
-- Para encontrar el Data File que lo contiene
-----------------------------------------------
SELECT df.type_desc,
       df.name,
       df.physical_name
FROM   sys.database_files df
WHERE  df.file_id = 4;

-----------------------------------------
-- Get the page dump for rows
-----------------------------------------
DBCC TRACEON(3604)
DBCC PAGE (Piscys, 4, 5644452, 1)
DBCC TRACEOFF(3604)