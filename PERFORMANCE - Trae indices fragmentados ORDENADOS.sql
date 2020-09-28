create table #indice ([DBNAME] varchar (10), objectid int, tipo varchar (50), fragmentacion int, paginas int)

insert into #indice (DBNAME, objectid, tipo, fragmentacion, paginas)

select DB_NAME(), 

         OBJECT_NAME([object_id]),

            index_type_desc,

          avg_fragmentation_in_percent, 

            page_count        

from sys.dm_db_index_physical_stats (DB_ID(), NULL,NULL,NULL,'SAMPLED')

where avg_fragmentation_in_percent > 50


 

select * from #indice order by fragmentacion desc

 

