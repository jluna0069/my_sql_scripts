select a.name, b.name, c.name from SYSOBJECTS a
join sys.columns b on a.id = b.object_id
join sys.types c on b.system_type_id = c.system_type_id and b.user_type_id = c.user_type_id
where a.xtype = 'U' and substring(c.name, 1,3) = 'DOM'