use piscys
go
SELECT 
  missing_index_group_stats.avg_total_user_cost * (missing_index_group_stats.avg_user_impact / 100.0) * (missing_index_group_stats.user_seeks + missing_index_group_stats.user_scans) AS improvement_measure, 
  'CREATE INDEX [missing_index_' + CONVERT (varchar, missing_index_group.index_group_handle) + '_' + CONVERT (varchar, missing_index_details.index_handle) 
  + '_' + LEFT (PARSENAME(missing_index_details.statement, 1), 32) + ']'
  + ' ON ' + missing_index_details.statement 
  + ' (' + ISNULL (missing_index_details.equality_columns,'') 
    + CASE WHEN missing_index_details.equality_columns IS NOT NULL AND missing_index_details.inequality_columns IS NOT NULL THEN ',' ELSE '' END 
    + ISNULL (missing_index_details.inequality_columns, '')
  + ')' 
  + ISNULL (' INCLUDE (' + missing_index_details.included_columns + ')', '') AS create_index_statement, 
  missing_index_group_stats.*, missing_index_details.database_id, missing_index_details.[object_id]
FROM sys.dm_db_missing_index_groups missing_index_group
INNER JOIN sys.dm_db_missing_index_group_stats missing_index_group_stats ON missing_index_group_stats.group_handle = missing_index_group.index_group_handle
INNER JOIN sys.dm_db_missing_index_details missing_index_details ON missing_index_group.index_handle = missing_index_details.index_handle
WHERE missing_index_group_stats.avg_total_user_cost * (missing_index_group_stats.avg_user_impact / 100.0) * (missing_index_group_stats.user_seeks + missing_index_group_stats.user_scans) > 10
ORDER BY missing_index_group_stats.avg_total_user_cost * missing_index_group_stats.avg_user_impact * (missing_index_group_stats.user_seeks + missing_index_group_stats.user_scans) DESC
