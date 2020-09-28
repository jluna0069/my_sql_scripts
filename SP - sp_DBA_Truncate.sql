/*crea tabla DBA_Truncate

En esta tabla se registran las tablas autorizadas a ser Borradas con Truncate
utilizando el sp_DBA_Truncate

La tabla y el SP deben ser creados en la base de datos donde exista la tabla a 
borrar con truncate
*/

create table DBA_Truncate (NombTbl varchar(100))
go

/*Inserta las tablas a DBA_Truncate*/

Insert into DBA_Truncate (NombTbl) Values ('Nombre Tabla')

Go

/* SP que ejecuta el truncate en contexto de owner.
se pasa como parametro el nombre de la tabla sin owner.
la tabla debe existir en DBA_Truncate
*/

Create PROCEDURE [dbo].[sp_DBA_Truncate] 

@Tabla varchar(500)
with execute as owner
AS
declare @comando varchar(1000)
Set @comando = 'truncate table ' + @Tabla

if (select count(*) from dbo.DBA_Truncate where NombTbl = @Tabla) = 1 
exec (@comando)
Else
Print 'No esta autorizado a realizar Truncate sobre la tabla ' + @Tabla