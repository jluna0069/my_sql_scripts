--------------------------------------------
-- OPERACIONES DE I/O QUE ESTÁN PENDIENTES
--------------------------------------------

select database_id, 
       file_id, 
       io_stall,
       io_pending_ms_ticks,
       scheduler_address 
from sys.dm_io_virtual_file_stats(default, default) iovfs,
     sys.dm_io_pending_io_requests as iopior
where iovfs.file_handle = iopior.io_handle
