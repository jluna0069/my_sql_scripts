USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[sp_VerificaProcesosBloqueados]    Script Date: 05/11/2009 12:42:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [dbo].[sp_VerificaProcesosBloqueados]
	@TiempoCorriendo int = 0 
as

set nocount on

Set @TiempoCorriendo = @TiempoCorriendo * -1

declare @bloqueos int 

select @bloqueos = count(*)
from master.dbo.sysprocesses (nolock)
 where loginame <> 'sa' 
	   and status <> 'sleeping' 
	   and cmd <> 'DBCC' 
	   and spid <> blocked and blocked <> ''
	   and last_batch <= DATEADD(mi, @TiempoCorriendo, getdate())

PRINT @bloqueos


RETURN




GO

/****** Object:  StoredProcedure [dbo].[sp_VerificaProcesosDemorados]    Script Date: 05/11/2009 12:42:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_VerificaProcesosDemorados]
	@TiempoCorriendo int = 0 
as

set nocount on

declare @Paraleliza int 
Set @TiempoCorriendo = @TiempoCorriendo * -1

select
	 @Paraleliza = COUNT(*)
     from master.dbo.sysprocesses (nolock)
     where loginame <> 'sa' 
	   and status <> 'sleeping' 
	   and cmd <> 'DBCC' 
	   and last_batch <= DATEADD(mi, @TiempoCorriendo, getdate())

PRINT @Paraleliza


RETURN




GO

/****** Object:  StoredProcedure [dbo].[sp_VerificaProcesosParalelizando]    Script Date: 05/11/2009 12:42:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [dbo].[sp_VerificaProcesosParalelizando]
	@TiempoCorriendo int = 0,
	@threads int = 1
as

set nocount on

declare @Paraleliza int 

set @paraleliza = 0

Set @TiempoCorriendo = @TiempoCorriendo * -1

select
	 @paraleliza = count(*)
     from master.dbo.sysprocesses (nolock)
     where loginame <> 'sa' 
	   and status <> 'sleeping' 
	   and cmd <> 'DBCC'
	   and last_batch <= DATEADD(mi, @TiempoCorriendo, getdate()) 
	   group by spid
	   having ((count(*) > 0 and @threads = 0) or (count(*) > @threads and @threads <> 0))

PRINT @Paraleliza

RETURN

GO


