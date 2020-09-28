declare @count int  
declare @count1 int    

set @count = 0  
set @count1 = 50000    

set rowcount 50000;    

while (select @count) <= (select count (*) from tabla1)
begin     
                UPDATE tabla1 SET campo = valor
                from tabla1 join ....
                where campo_tipo_identity between @count and @count1    
                
                select @count = 50000 + @count  
                select @count1 = 50000 + @count1    
end