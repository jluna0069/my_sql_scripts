exec master..xp_fixeddrives

--exec sp_who2 active

dbcc sqlperf (logspace)

/*Solo Instancias 2005 y 2008*/
--select * from sys.databases where state_desc <> 'online' 


/* LISTA INFO DE FILES ABAJO COMENZARIA LA PARTE DE LOG */
/********************************************************/

use master

/* Data */
CREATE TABLE #t
(
[fileid]       int,
[filegroup]    int, 
[totalextents] dec(10,2) , 			/**/
[usedextents]  dec(10,2),			/**/
[Name]         varchar(1024),
[filename]     varchar(1024)
)

/* Crea table para lineas de log */	/* Log */
CREATE TABLE #t1
([Name]         	varchar(1024),
 [totalextents] 	dec(10,2), 
 [PorcentajeLibre]	dec(9,2),
 [status]		int
)

Declare @Ejecutar char(18)
Declare @nombre   varchar(50)
declare @usar     varchar(120)

/*   loop para recorrer todas las BD del Servidor   */

declare @ejecucion varchar(200)
declare @cantidad int
declare @contador int
    set @contador = 0

Select IDENTITY(int, 1,1) as Ident, [name] into #temp_space from sysdatabases 
 where name <> 'DBA' 
   and name <> 'msdb' 
   and name <> 'model' 
   and name <> 'master' 


/* Select * From #temp_space  */

select @cantidad = COUNT(*) from #temp_space

/* Recorre tempotal  */
While (@contador <= @cantidad  )
Begin
   set @contador = @contador + 1         
   select @ejecucion = 'use ' + rtrim(name) + ' dbcc showfilestats' from #temp_space Where Ident = @contador

   insert into #t execute(@ejecucion) 

   If @contador = @cantidad
      Break
   Else
      Continue
   /* insert into #t execute(@ejecucion) */
End



Alter Table #t Add PorcentajeLibre decimal(9,2) default 0
go 
update #t set totalextents = (totalextents * 64 / 1024), usedextents = (usedextents * 64 / 1024), PorcentajeLibre = ((totalextents-usedextents) * 100) / totalextents   
go 



insert into #t1 exec('dbcc sqlperf(logspace)')
delete from #t1 where Name = 'master'
delete from #t1 where Name = 'msdb'
delete from #t1 where Name = 'model'
delete from #t1 where Name = 'tempdb'


/*insert into #t
select 0 as [fileid],0 as [filegroup],totalextents,0 as usedextents,[Name],'Log' as filenane,PorcentajeLibre
from #t1

*/





select [Name],[filename],[totalextents],[usedextents],PorcentajeLibre,[fileid],[filegroup] from #t order by Name


/* drop table #t */
drop table #temp_space
drop table #t
drop table #t1

/* hASTA AQUI LISTA INFO DE FILES ABAJO COMENZARIA LA PARTE DE LOG */
/*******************************************************************/
-- dbcc sqlperf(logspace)

/* insert into #t execute(dbcc perflog) */
/*DROP table #temp_space*/
/* Informacion del Log */
/*
CREATE TABLE #t1
(
[Name]         varchar(1024),
[totalextents] dec(10,2), 
[usedextents]  dec(10,2),
[status]       int
)

insert into #t1 exec('dbcc sqlperf(logspace)')

INSERT INTO #t SELECT 0 as fileid, 0 as [filegroup], [totalextents],[usedextents], [name], ' ' as [filename]
   FROM #t1

Select * from #t 

DROP table #t
DROP table #t1
DROP table #temp_space

*/
