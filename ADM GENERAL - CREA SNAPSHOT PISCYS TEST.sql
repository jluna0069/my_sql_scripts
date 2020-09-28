USE [master]
GO

CREATE DATABASE PISCYS_SNAPSHOT ON
( NAME = N'PISCYS_Data', FILENAME = N'G:\SQL\sqlData\PISCYS_Data.snap'), 
( NAME = N'PISCYS_Data_TG_P1', FILENAME = N'G:\SQL\sqlData\PISCYS_Data_TG_P1.snap'), 
( NAME = N'PISCYS_Data_TG_P2', FILENAME = N'G:\SQL\sqlData\PISCYS_Data_TG_P2.snap'), 
( NAME = N'PISCYS_Data_PR1', FILENAME = N'G:\SQL\sqlData\PISCYS_Data_PR1.snap'), 
( NAME = N'PISCYS_Data_PR2', FILENAME = N'G:\SQL\sqlData\PISCYS_Data_PR2.snap')
AS SNAPSHOT OF PISCYS


RESTORE DATABASE PISCYS
FROM DATABASE_SNAPSHOT='PISCYS_SNAPSHOT'

DROP DATABASE PISCYS_SNAPSHOT 