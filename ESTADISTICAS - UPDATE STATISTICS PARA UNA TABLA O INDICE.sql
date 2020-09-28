USE master
go

-- Actualizar todas las estadísticas en una tabla
--En este ejemplo se actualizan las estadísticas de todos los índices de la tabla SalesOrderDetail.
USE AdventureWorks2008R2;
GO
UPDATE STATISTICS Esquema.Tabla;
GO

-- Actualizar las estadísticas para un índice
--En este ejemplo se actualizan las estadísticas del índice AK_SalesOrderDetail_rowguid de la tabla SalesOrderDetail.
USE xxxx;
GO
UPDATE STATISTICS Esquema.Tabla Índice;
GO

-- Actualizar estadísticas utilizando FULLSCAN y NORECOMPUTE
-- En este ejemplo se actualizan las estadísticas de Products de la tabla Product, se exige un examen completo de todas las filas de la tabla Product y se desactivan las estadísticas automáticas para las estadísticas de Products.
USE xxxx;
GO
UPDATE STATISTICS Production.Product(Products)
    WITH FULLSCAN, NORECOMPUTE;
GO