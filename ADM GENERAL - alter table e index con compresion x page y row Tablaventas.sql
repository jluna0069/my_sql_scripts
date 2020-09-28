--Facts_Ventas07 

ALTER TABLE Facts_Ventas07 REBUILD WITH (DATA_COMPRESSION = PAGE);
GO

ALTER INDEX IE_Fecha_Ventas07 ON dbo.Facts_Ventas07 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IE_Tickets_Ventas07 ON dbo.Facts_Ventas07 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IX_FECHA ON dbo.Facts_Ventas07 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IX_scanning_fecha ON dbo.Facts_Ventas07 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO


--Facts_Ventas08

ALTER TABLE Facts_Ventas08 REBUILD WITH (DATA_COMPRESSION = PAGE);
GO

ALTER INDEX IE_Fecha_Ventas08 ON dbo.Facts_Ventas08 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IE_Tickets_Ventas08 ON dbo.Facts_Ventas08 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IX_FECHA ON dbo.Facts_Ventas08 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

ALTER INDEX IX_scanning_fecha ON dbo.Facts_Ventas08 REBUILD WITH ( DATA_COMPRESSION = PAGE ) ;
GO

--Facts_Ventas09
print getdate()
go
ALTER TABLE Facts_Ventas09 REBUILD WITH (DATA_COMPRESSION = ROW);
GO
print getdate()
Print'Termino Facts_Ventas09'
go

print getdate()
go
ALTER INDEX IE_Fecha_Ventas09 ON dbo.Facts_Ventas09 REBUILD WITH ( DATA_COMPRESSION = ROW ) ;
GO
print getdate()
Print'Termino Facts_Ventas09'
go

print getdate()
go
ALTER INDEX IE_Tickets_Ventas09 ON dbo.Facts_Ventas09 REBUILD WITH ( DATA_COMPRESSION = ROW ) ;
GO
print getdate()
Print'Termino Facts_Ventas09'
go

print getdate()
go
ALTER INDEX IX_FECHA ON dbo.Facts_Ventas09 REBUILD WITH ( DATA_COMPRESSION = ROW ) ;
GO
print getdate()
Print'Termino Facts_Ventas09'
go

print getdate()
go
ALTER INDEX IX_scanning_fecha ON dbo.Facts_Ventas09 REBUILD WITH ( DATA_COMPRESSION = ROW ) ;
GO
print getdate()
Print'Termino Facts_Ventas09'
go