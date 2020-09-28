USE master
go

UPDATE STATISTICS table_or_indexed_view_name 
    [ 
        { 
            { index_or_statistics__name }
          | ( { index_or_statistics_name } [ ,...n ] ) 
                }
    ] 
    [    WITH 
        [ 
            [ FULLSCAN ] 
            | SAMPLE number { PERCENT | ROWS } ] 
            | RESAMPLE 
            | <update_stats_stream_option> [ ,...n ]
        ] 
        [ [ , ] [ ALL | COLUMNS | INDEX ] 
        [ [ , ] NORECOMPUTE ] 
    ] ;

<update_stats_stream_option> ::=
    [ STATS_STREAM = stats_stream ]
    [ ROWCOUNT = numeric_constant ]
    [ PAGECOUNT = numeric contant ]



-- Actualizar todas las estadísticas en una tabla
--En este ejemplo se actualizan las estadísticas de todos los índices de la tabla SalesOrderDetail.

USE AdventureWorks2008R2;
GO
UPDATE STATISTICS Sales.SalesOrderDetail;
GO


-- Actualizar las estadísticas para un índice
--En este ejemplo se actualizan las estadísticas del índice AK_SalesOrderDetail_rowguid de la tabla SalesOrderDetail.

USE AdventureWorks2008R2;
GO
UPDATE STATISTICS Sales.SalesOrderDetail AK_SalesOrderDetail_rowguid;
GO


-- Actualizar las estadísticas con un muestreo del 50%
--En este ejemplo se crean y, después, se actualizan las estadísticas de las columnas Name y ProductNumber de la tabla Product.

USE AdventureWorks2008R2;
GO
CREATE STATISTICS Products
    ON Production.Product ([Name], ProductNumber)
    WITH SAMPLE 50 PERCENT
-- Time passes. The UPDATE STATISTICS statement is then executed.
UPDATE STATISTICS Production.Product(Products) 
    WITH SAMPLE 50 PERCENT;


-- Actualizar estadísticas utilizando FULLSCAN y NORECOMPUTE
-- En este ejemplo se actualizan las estadísticas de Products de la tabla Product, se exige un examen completo de todas las filas de la tabla Product y se desactivan las estadísticas automáticas para las estadísticas de Products.

 USE AdventureWorks2008R2;
GO
UPDATE STATISTICS Production.Product(Products)
    WITH FULLSCAN, NORECOMPUTE;
GO


