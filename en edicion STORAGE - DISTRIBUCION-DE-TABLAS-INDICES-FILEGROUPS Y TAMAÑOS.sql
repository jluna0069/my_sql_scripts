USE asdirect
go

/*
select 'table_name'=object_name(i.id)  ,i.indid
,'index_name'=i.name  ,i.groupid
,'filegroup'=f.name  ,'file_name'=d.physical_name
,'dataspace'=s.name 
from sys.sysindexes i ,sys.filegroups f  ,sys.database_files d ,sys.data_spaces s
where objectproperty(i.id,'IsUserTable') = 1
and f.data_space_id = i.groupid
and f.data_space_id = d.data_space_id
and f.data_space_id = s.data_space_id
order by f.name,object_name(i.id),groupid
go
*/


SELECT
	t.NAME AS TableName,
    s.Name AS SchemaName,
    i.name AS IndexName,
    i.type_desc AS TipoIndice,
    p.rows AS RowsPartition,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM 
    sys.tables t
LEFT OUTER JOIN -- TABLES enlaza con SCHEMAS
    sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN      -- TABLES enlaza con INDEXES
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN -- INDEXES enlaza con PARTITIONS
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN -- PARTITIONS enlaza con ALLOCATION_UNITS
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name,i.name,i.type_desc, p.Rows
ORDER BY 
    t.Name
    
    
    
      SELECT object_name(o.object_id) as NombreObjeto,
		   o.name,
		   CASE o.parent_object_id
				WHEN 0 THEN object_name(o.object_id)
				ELSE object_name(o.parent_object_id)
			END,
		   o.[type], 
		   o.type_desc
    FROM sys.objects o
    WHERE o.[type] NOT IN ('P','FN','F','D','TR')