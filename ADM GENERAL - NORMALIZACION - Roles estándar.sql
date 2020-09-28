USE [WSS_Search_ACEN0418]
GO

CREATE ROLE Role_Compilacion AUTHORIZATION dbo
exec dbo.sp_addrolemember 'db_ddladmin', 'Role_Compilacion'

CREATE ROLE Role_Consulta AUTHORIZATION dbo
exec dbo.sp_addrolemember 'db_datareader', 'Role_Consulta'

CREATE ROLE Role_Ejecucion AUTHORIZATION dbo
GRANT EXECUTE TO Role_Ejecucion

CREATE ROLE Role_Modificacion AUTHORIZATION dbo
exec dbo.sp_addrolemember 'db_datareader', 'Role_Consulta'
exec dbo.sp_addrolemember 'db_datawriter', 'Role_Modificacion'

CREATE ROLE Role_ViewDefinition AUTHORIZATION dbo
GRANT VIEW DEFINITION TO Role_ViewDefinition

