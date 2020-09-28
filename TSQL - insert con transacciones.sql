
drop table #prueba1;
drop table #prueba2;

create table #prueba1(campo1 varchar(100), campo2 varchar(100));
create table #prueba2(campo1 varchar(100), campo2 varchar(100));

set rowcount 0;

declare @campo int
set @campo = 0

while (@campo <> 100)
begin 

select * from #prueba1 
insert into #prueba1 (campo1, campo2) values(@campo, @campo)

set @campo= @campo +1

end

select * from #prueba1


set rowcount 10;

while (select count(*) from #prueba1) <> (select count(*) from #prueba2)
begin 

insert into #prueba2
select * from #prueba1 a
where not exists 
	(select * from #prueba2 b where a.campo1 = b.campo1 and a.campo2 = b.campo2)

end

set rowcount 0;

select * from #prueba2