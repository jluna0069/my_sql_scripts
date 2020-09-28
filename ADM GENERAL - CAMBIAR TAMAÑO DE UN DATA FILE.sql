USE MASTER
go
ALTER DATABASE Inventario_Prueba_Data
MODIFY FILE 
(
NAME = Inventario_Prueba_Data,
FILENAME = 'E:\SQLDATABASES\Bases de Datos Generales\GestionDocumental_Data.MDF', SIZE = 10MB)
go