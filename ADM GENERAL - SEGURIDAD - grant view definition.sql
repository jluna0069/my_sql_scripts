use [ASDirect]
GO

select 'GRANT VIEW DEFINITION ON [dbo].[' + name + '] TO [GRUPOASOCIART\gps]' + '
GO'
from sys.objects where type_desc in ('SQL_STORED_PROCEDURE', 'USER_TABLE')
order by type_desc