use pis_integracion_hist
go
drop table #indice

create table #indice ([DBNAME] varchar (50), objectname varchar(100), tipo varchar (50), fragmentacion int, paginas int)

insert into #indice (DBNAME, objectname, tipo, fragmentacion, paginas)

select TOP 50 DB_NAME(), 

         OBJECT_NAME([object_id]),

            index_type_desc,

          avg_fragmentation_in_percent, 

            page_count        

from sys.dm_db_index_physical_stats (DB_ID('pis_integracion_hist'), NULL,NULL,NULL,NULL)

where avg_fragmentation_in_percent > 15



select * from #indice order by fragmentacion desc

 

