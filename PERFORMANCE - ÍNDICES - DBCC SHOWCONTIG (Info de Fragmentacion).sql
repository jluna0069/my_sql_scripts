--Show fragmentation information on all indexes in a database
--Clean up the display
SET NOCOUNT ON

--Use the pubs database
USE C21

DBCC SHOWCONTIG WITH ALL_INDEXES
GOQuery to show fragmentation information on all indexes on a table--Show fragmentation information on all indexes on a table
--Clean up the display
SET NOCOUNT ON

--Use the pubs database
USE C24
DBCC SHOWCONTIG (PPOIX) WITH ALL_INDEXES
GO
--Show fragmentation information on a specific index
--Clean up the display
SET NOCOUNT ON

