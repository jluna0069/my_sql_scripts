alter procedure prueba_diego
	@entrada bit,
	@retorno bit OUTPUT
as

set @retorno = 0

if @entrada = 1
set @retorno = 1

-- fin

-- prueba

declare @retorno bit
	

exec prueba_diego 0, @retorno

if @retorno = 1 print 'retorno = 1'
else print 'retorno = 0'

