use asdirect
go
/*
SELECT o.object_id as IDObjeto,
		   object_name(o.object_id) as NombreObjeto,
		   /*CASE o.parent_object_id
				WHEN 0 THEN object_name(o.object_id)
				ELSE object_name(o.parent_object_id)
		   END,*/
		   o.[type], 
		   o.type_desc,
		   i.object_id as ID_INDEXES,
		   i.type_desc as TIPO_INDICE,		  
	       i.name as NOMBRE,
	       s.name,
	   	   a.type_desc AS allocation_type,
	   	   a.data_pages AS data_pages,
			p.rows AS RowsPartition,
			SUM(a.total_pages) * 8 AS TotalSpaceKB, 
			SUM(a.used_pages) * 8 AS UsedSpaceKB, 
			(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB  
    FROM sys.objects o
    INNER  JOIN sys.indexes i ON o.object_id = i.object_id
    INNER JOIN sys.data_spaces s ON i.data_space_id = s.data_space_id
    INNER  JOIN sys.partitions p ON o.object_id = p.object_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
    AND  s.data_space_id = a.data_space_id
	WHERE o.[type] NOT IN ('P','FN','F','D','TR')
	GROUP BY 
		o.object_id,
		object_name(o.object_id),
		o.[type], 
		o.type_desc,
		i.object_id,
		i.type_desc,		  
		i.name,
		s.name,
		a.type_desc,
		--d.physical_name,
		a.data_pages,
		p.rows
    ORDER BY object_name(o.object_id),a.data_pages desc--object_name(o.object_id)
    
    */
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
/*
use asdirect
go
SELECT	t.Name as [Table Name],

		s.Name as [Schema Name],

		i.name as [Index Name],			
		i.index_id as [Index ID],

		ixUSG.page_count as [No. Pages],
		ixUSG.index_type_desc,
		ixUSG.alloc_unit_type_desc,

		convert(float,ixUSG.page_count*8.00/1024.00) as [Used Space (MB)]

		FROM	 sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL , NULL)  ixUSG

			join sys.indexes i on ixUSG.object_id = i.object_id 
							   and ixUSG.index_id = i.index_id

			join sys.tables	 t on t.object_id = ixUSG.object_id 

			join sys.schemas s on s.schema_id= t.schema_id
			order by t.name 
			
			*/