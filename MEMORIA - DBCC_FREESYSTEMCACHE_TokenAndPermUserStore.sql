use DBA
Go

CREATE TABLE [dbo].[TokenAndPermUserStore](
    [loaddate] [datetime] NOT NULL,
    [sizemb] [decimal](10, 2) NULL,
    CONSTRAINT [PK_TokenAndPermUserStore] PRIMARY KEY CLUSTERED
    (
        [loaddate]
    )
)
go

CREATE TABLE [dbo].[TokenAndPermFlush](
    [Flushdate] [datetime] NOT NULL,
    [SizeMBBefore] [numeric](10, 2) NOT NULL,
    [SizeMBAfter] [numeric](10, 2) NOT NULL,
    CONSTRAINT [PK_TokenAndPermFlush] PRIMARY KEY CLUSTERED
    (
        [Flushdate]
    )
)
go


alter procedure sp_DBA_FREESYSTEMCACHE_TokenAndPermUserStore
@ThresholdMB numeric(10,2)
as
--Then we need to set up a job to run the following TSQL which will track the size and also flush if it breaches a threshold

declare @SizeMBBefore numeric(10,2)
declare @SizeMBAfter numeric(10,2)

-- set threshold here
--declare @ThresholdMB numeric(10,2) ; 
set @ThresholdMB = 256.0

select @SizeMBBefore = SUM(single_pages_kb + multi_pages_kb)/1024.0
from sys.dm_os_memory_clerks
where [name] = 'TokenAndPermUserStore'

insert dbo.TokenAndPermUserStore(loaddate,sizemb)
select getdate(),@SizeMBBefore

if @SizeMBBefore >= @ThresholdMB
begin

    DBCC FREESYSTEMCACHE ('TokenAndPermUserStore')
    print 'Cleared TokenAndPermUserStore'

    select @SizeMBAfter = SUM(single_pages_kb + multi_pages_kb)/1024.0
    FROM sys.dm_os_memory_clerks
    WHERE name = 'TokenAndPermUserStore'
    insert dbo.TokenAndPermFlush select getdate(),@SizeMBBefore,@SizeMBAfter
    
    print 'corrio el proceso'

end

delete dbo.TokenAndPermUserStore where loaddate < dateadd(dd,-14,getdate())
delete dbo.TokenAndPermFlush where Flushdate < dateadd(dd,-14,getdate())

GO