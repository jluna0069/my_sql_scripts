USE [master]
GO
CREATE DATABASE [BizTalkMsgBoxDb] ON 
( FILENAME = N'F:\MSSQL.1\MSSQL\Data\BizTalkMsgBoxDb.mdf' ),
( FILENAME = N'F:\MSSQL.1\MSSQL\DATA\BizTalkMsgBoxDb_log.LDF' ),
( FILENAME = N'G:\MSSQL.1\MSSQL\Data\BizTalkMsgBoxDb_Data_002.ndf' ),
( FILENAME = N'H:\MSSQL.1\MSSQL\Data\BizTalkMsgBoxDb_Data_003.ndf' ),
( FILENAME = N'I:\MSSQL.1\MSSQL\Data\BizTalkMsgBoxDb_Data_004.ndf' )
 FOR ATTACH_REBUILD_LOG

--otro:
sp_attach_single_file_db 'BizTalkMsgBoxDb',N'F:\MSSQL.1\MSSQL\Data\BizTalkMsgBoxDb.mdf'