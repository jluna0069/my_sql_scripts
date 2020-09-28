use master
go
ALTER DATABASE AS_Medicina_Preventiva SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go
EXEC sp_detach_db N'AS_Medicina_Preventiva'




EXEC sp_attach_db 
	@dbname = N'AS_Medicina_Preventiva', 
    @filename1 = N'Z:\MSSQL.1\MSSQL\Data\AS_MedicinaPreventiva.mdf', 
    @filename2 = N'Z:\MSSQL.1\MSSQL\Data\AS_MedicinaPreventiva_.ndf',
    @filename3 = N'Z:\MSSQL.1\MSSQL\Data\AS_MedicinaPreventiva_2.ldf';





