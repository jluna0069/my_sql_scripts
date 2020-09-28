------------------------------------------------------------------------------------------------------------------------
--IMPORTANTE: Correr fuera de horario de atención al público. Volcar resultado a Excel y ordenar y filtrar allí mismo.
------------------------------------------------------------------------------------------------------------------------

use piscys
go
select  
		DB_NAME(), 
        OBJECT_NAME([object_id]),
        index_type_desc,
        avg_fragmentation_in_percent, 
        page_count        
from sys.dm_db_index_physical_stats (DB_ID(), NULL,NULL,NULL,'sampled')
WHERE  avg_fragmentation_in_percent > 30
--order by avg_fragmentation_in_percent desc