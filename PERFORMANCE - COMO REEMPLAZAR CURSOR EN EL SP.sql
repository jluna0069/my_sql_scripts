ALTER PROCEDURE [dbo].[sp_XXXXX] 
AS
BEGIN
declare XXXXX
declare @contador int
		

-- EL SELECT DEL CURSOR SE REEMPLAZA POR UN 'SELECT INTO' A UNA TABLA TEMPORAL

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- IMPORTANTE: ASEGURARSE DE CONTAR EN LA TABLA TEMPORAL CON AL MENOS UN CAMPO ÚNICO, NUMERICO Y ORDENADO.
-- SI NINGÚN CAMPO DE LA TABLA ORIGINAL CUMPLE DICHAS CARACTERISTICAS, SE PUEDE CREAR UN CAMPO IDENITY EN LA TABLA TEMPORAL.
-- ESTE CAMPO NUMÉRICO, ÚNICO Y ORDENADO SERVIRÁ PARA RECORRER LA TABLA.
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

		SELECT ID = IDENTITY(1,1),
			   XXX INTO #tabla_temporal
		FROM XXXX
		WHERE XXX

-- QUITAR EL 'OPEN' DEL CURSOR
-- QUITAR EL 'FETCH NEXT'
-- REEMPLAZAR 'WHILE @@FETCH_STATUS = 0' POR 'WHILE (select count(*) from #tabla_temporal) > 0'
		SET @contador = 1

		WHILE (select count(*) from #tabla_temporal) > 0
		BEGIN

		-- NI BIEN SE ABRE EL WHILE, REALIZAR 'SELECT TOP 1' DE LA TABLA TEMPORAL, CON ASIGNACION DE VALORES A LAS VARIABLES
		
			
			select top 1 @variable1 = XXX,
						 @variable2 = XXX,
						 @variable3 = XXX,
						 @variable4 = XXX
			from #tabla_temporal
			where id = @contador
			
			
		    -- ACÁ VIENE EL PROCESAMIENTO DE LOS DATOS DEL REGISTRO.
		    
			XXXXXX
			XXXXXX
			XXXXXX
			
			-- AL FINAL DEL 'WHILE' SE BORRA DE LA TEMPORAL EL REGISTRO RECIENTEMENTE PROCESADO.
			
			DELETE #tabla_temporal 
			WHERE XXX = @variable1,
			AND	  XXX = @variable2,
			AND	  XXX = @variable3,
			AND	  XXX = @variable4
			where id = @contador
			
			SET @contador = @contador + 1

			-- QUITAR EL ÚLTIMO 'FETCH NEXT'
		END
-- QUITAR EL 'CLOSE' DEL CURSOR
-- QUITAR EL 'DEALLOCATE'