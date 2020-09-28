
USE master;
GO

-- Dejamos el recovery de la base en SIMPLE (sin backup de logs)
ALTER DATABASE Piscys_20180328 SET RECOVERY SIMPLE
go

use Piscys_20180328
go
-- Reducimos el log a un tamaño menor del que finalmente va a tener porque luego el MODIFY FILE permite incrementar valor pero no reducirlo.
-- En este caso, lo voy a dejar en 5GB pero empiezo reduciéndolo a 4,5GB.
dbcc shrinkfile (PISCYS_Log, 4608)
go


USE master;
GO

-- Finalmente seteamos el Log en los 5GB finales con posibilidad que crezca hasta 10GB.
ALTER DATABASE Piscys_20180328
MODIFY FILE
    (NAME = PISCYS_Log,
    SIZE = 5120MB, MAXSIZE=10240MB);
GO
