USE master
go

-- Actualizar todas las estad�sticas en una tabla
--En este ejemplo se actualizan las estad�sticas de todos los �ndices de la tabla SalesOrderDetail.
USE AdventureWorks2008R2;
GO
UPDATE STATISTICS Esquema.Tabla;
GO

-- Actualizar las estad�sticas para un �ndice
--En este ejemplo se actualizan las estad�sticas del �ndice AK_SalesOrderDetail_rowguid de la tabla SalesOrderDetail.
USE xxxx;
GO
UPDATE STATISTICS Esquema.Tabla �ndice;
GO

-- Actualizar estad�sticas utilizando FULLSCAN y NORECOMPUTE
-- En este ejemplo se actualizan las estad�sticas de Products de la tabla Product, se exige un examen completo de todas las filas de la tabla Product y se desactivan las estad�sticas autom�ticas para las estad�sticas de Products.
USE xxxx;
GO
UPDATE STATISTICS Production.Product(Products)
    WITH FULLSCAN, NORECOMPUTE;
GO