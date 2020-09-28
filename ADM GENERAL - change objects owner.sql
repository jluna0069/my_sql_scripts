select 'EXEC sp_changeobjectowner ' + '''' + rtrim(name) + ''',' + '''des''' 
from sysobjects where xtype = 'U' and user_name(uid) <> 'des'
order by name

select * from sysobjects where xtype = 'U' and user_name(uid) <> 'prd'


select user_name(uid) from sysobjects where xtype = 'U' 

EXEC sp_changeobjectowner 'sap_tmp_stmt_stats_tab'

EXEC sp_changeobjectowner 'sap_tmp_stmt_stats_tab','prd'