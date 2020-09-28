USE ASDIRECT
go

DECLARE @intIdCliente int
DECLARE @Numero char(10)
DECLARE @Calle varchar(250)
DECLARE @Localidad varchar(250)
DECLARE @CP char(4)
DECLARE @IntIdProvincia int
DECLARE @Provincia varchar(250)
DECLARE @IdDomicilio int
-- VARIABLES DEL WHILE

DECLARE @iIterador	int,
		@iRowCount	int

DECLARE	@iActualRowID	int,
		@var_intIDCliente INT,
		@var_varNumero varchar(10),
		@var_varCalleDesnormalizada_varNumero varchar(250),
		@var_varLocDesnormalizada varchar(250),
		@var_varCPDesnormalizado varchar(8),
		@var_intIdProvDesnormalizada int,
		@var_varDescripcion varchar(250)

DECLARE @VarTable TABLE 
(
  RowID int IDENTITY, 
  var_intIDCliente INT,
  var_varNumero varchar(10),
  var_varCalleDesnormalizada_varNumero varchar(250),
  var_varLocDesnormalizada varchar(250),
  var_varCPDesnormalizado varchar(8),
  var_intIdProvDesnormalizada int,
  var_varDescripcion varchar(250)
)

SET @iIterador = 1

CREATE TABLE #TempTable
(
  RowID int IDENTITY, 
  temp_intIDCliente INT,
  temp_varNumero varchar(10),
  temp_varCalleDesnormalizada_varNumero varchar(250),
  temp_varLocDesnormalizada varchar(250),
  temp_varCPDesnormalizado varchar(8),
  temp_intIdProvDesnormalizada int,
  temp_varDescripcion varchar(250)
)

INSERT INTO #TempTable
	SELECT 
	ali.intIdCliente,
	gen.[varNumero],
	rtrim(ltrim(gen.[varCalleDesnormalizada] + ' ' + gen.[varNumero])),
	gen.[varLocDesnormalizada],
	SUBSTRING(gen.[varCPDesnormalizado],1,4),
	gen.[intIdProvDesnormalizada],
	gp.varDescripcion
	 FROM 
	[ASDirect].[dbo].[ALI_Cliente] ali
	INNER JOIN [PISCYS].[dbo].[COM_Clientes] cli ON ali.[varCUIT] = cli.[chrCUITCUILCDI]
	INNER JOIN [PISCYS].[dbo].[COM_DomiciliosCliente] dom ON cli.[intIdCliente] = dom.[intIdCliente] AND dom.[intIdTipoDomicilio] = 1
	INNER JOIN [PISCYS].[dbo].[GEN_Domicilios] gen ON dom.[intIdDomicilio] = gen.[intIdDomicilio]
	INNER JOIN [PISCYS].[dbo].GEN_Provincias gp ON gp.intIdProvincia=gen.intIdProvDesnormalizada
	where ali.intIdDomicilio IS NULL
	ORDER BY ali.intIdCliente asc
	

set @iRowCount = @@ROWCOUNT

create clustered index idx_tmp on #TempTable(RowID) WITH FILLFACTOR = 100

WHILE @iIterador <= @iRowCount 
	BEGIN
	SELECT   RowID int IDENTITY, 
  @var_intIDCliente						= temp_intIDCliente,
  @var_varNumero						= temp_varNumero,
  @var_varCalleDesnormalizada_varNumero = temp_varCalleDesnormalizada_varNumero,
  @var_varLocDesnormalizada				= temp_varLocDesnormalizada,
  @var_varCPDesnormalizado				= temp_varCPDesnormalizado,
  @var_intIdProvDesnormalizada			= temp_intIdProvDesnormalizada,
  @var_temp_varDescripcion				= temp_varDescripcion
  
select count(*) from #TempTable
--DROP TABLE #TempTable
--while (select count(*) from #TempTable) <> 0

--	PRINT 'TIENE DATOS'


/*
SELECT @iControlBucle = 1

SELECT @iProximoRowID = MIN(RowId)
FROM @VarTemp

IF ISNULL(@iProximoRowID,0) = 0 THEN
	BEGIN
		SELECT 'No hay registros en la tabla'
		RETURN
	END

-- TRAE EL PRIMER REGISTRO
SELECT  @iActualRowID		 = RowID--, 
		--@var_intIDCliente	 = var_intIDCliente,
		--@var_varNumero		 = var_varNumero,
		--@var_varCalleDesnor  = var_varCalleDesnormalizada_varNumero,
		--@var_varLocDesnor	 = var_varLocDesnormalizada,
		--@var_varCPDesnor	 = var_varCPDesnormalizado,
		--@var_intIdProvDesnor = var_intIdProvDesnormalizada,
		--@var_varDescripcion  = var_varDescripcion
  FROM @VarTemp
 WHERE RowID = @iProximoRowID
 
 WHILE @iControlBucle = 1
 
	BEGIN
		SELECT @iProximoRowID = MIN(RowId)
		FROM @VarTemp
		
		IF ISNULL(@iProximoRowID,0) = 0 THEN
			BEGIN
				SELECT 'No hay registros en la tabla'
				RETURN
		END
		
		SELECT  @iActualRowID		 = RowID, 
				@var_intIDCliente	 = var_intIDCliente,
				@var_varNumero		 = var_varNumero,
				@var_varCalleDesnor  = var_varCalleDesnormalizada_varNumero,
				@var_varLocDesnor	 = var_varLocDesnormalizada,
				@var_varCPDesnor	 = var_varCPDesnormalizado,
				@var_intIdProvDesnor = var_intIdProvDesnormalizada,
				@var_varDescripcion  = var_varDescripcion
		  FROM  @VarTemp
		 WHERE  RowID = @iProximoRowID
		 */