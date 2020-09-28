use XXX
go
CREATE TABLE #TableSizes
(
            TableName NVARCHAR(255),
            TableRows INT,
            ReservedSpaceKB VARCHAR(20),
            DataSpaceKB VARCHAR(20),
            IndexSizeKB VARCHAR(20),
            UnusedSpaceKB VARCHAR(20)
)

INSERT INTO #TableSizes
exec sp_MSforeachtable 'exec sp_spaceused "?"'
go

SELECT * FROM #TableSizes
ORDER BY TableRows DESC
go