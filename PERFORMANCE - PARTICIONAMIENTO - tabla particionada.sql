CREATE TABLE PartitionTable (col1 int, col2 char(10))
;
GO
CREATE TABLE NonPartitionTable (col1 int, col2 char(10))
 ;
GO

ALTER TABLE NonPartitionTable  SWITCH TO PartitionTable;
GO


insert into NonPartitionTable (col1, col2) values (1,'diego')
insert into NonPartitionTable (col1, col2) values (2,'adriel')


CREATE PARTITION FUNCTION myRangePF1 (int)
AS RANGE LEFT FOR VALUES (1);


CREATE PARTITION SCHEME myRangePS1
AS PARTITION myRangePF1
TO ([PRIMARY])


select * from PartitionTable
select * from NonPartitionTable

drop table PartitionTable
drop table NonPartitionTable