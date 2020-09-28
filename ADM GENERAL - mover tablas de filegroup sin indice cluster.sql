set nocount on
go

create table #tablas(nombre varchar(1000))

insert into #tablas
	select distinct '[' + user_name(a.uid) + '].[' + a.name  + ']'
	from sysobjects a join sysindexes b on a.id = b.id
	where a.xtype = 'U' and b.groupid <> 1 and b.name not like '%_WA_%'

declare @nombre varchar(1000)

while (select count(*)from #tablas) <> 0
begin

	
select top 1 @nombre = nombre from #tablas

print 'print ''' + @nombre + '''
go'

print 'delete sysindexes from sysobjects a join sysindexes b on a.id = b.id where a.xtype = ''U'' and b.name like ''%_WA_%'' and ''['' + user_name(a.uid) + ''].['' + a.name  + '']'' = ''' + rtrim(ltrim(@nombre)) + '''
go'
print '
'	
print 'alter table ' + rtrim(ltrim(@nombre)) + ' add CAMPO int IDENTITY(1,1) NOT NULL' + '
go'
print '
'	
print 'create clustered index PEPE on ' + rtrim(ltrim(@nombre)) + '(CAMPO) ON [PRIMARY]' + '
go'
print '
'	
print 'drop index ' + rtrim(ltrim(@nombre)) + '.PEPE' + ' 
go'
print '
'	
print 'alter table ' + rtrim(ltrim(@nombre)) + ' drop column CAMPO' + ' 
go'
print '
'

delete #tablas where nombre = @nombre

end

drop table #tablas