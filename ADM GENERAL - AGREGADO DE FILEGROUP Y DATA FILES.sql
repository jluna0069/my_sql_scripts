-- AGREGO UN FILEGROUP A LA BD
ALTER DATABASE DW ADD FILEGROUP [DW_DATA_FT_FG]

-- AGREGO LOS DATA FILES AL FILEGROUP
ALTER DATABASE DW
ADD FILE
( NAME = DW_FT_Data_01,
FILENAME = 'C:\SQLServer\MSSQL10_50.SQL2008R2\MSSQL\DATA\DW_FT_Data_01.ndf',
SIZE = 1024MB,
FILEGROWTH = 1MB)
TO FILEGROUP [DW_DATA_FT_FG]
GO
ALTER DATABASE DW
ADD FILE
( NAME = DW_FT_Data_02,
FILENAME = 'C:\SQLServer\MSSQL10_50.SQL2008R2\MSSQL\DATA\DW_FT_Data_02.ndf',
SIZE = 1024MB,
FILEGROWTH = 1MB)
TO FILEGROUP [DW_DATA_FT_FG]
go
ALTER DATABASE DW
ADD FILE
( NAME = DW_FT_Data_03,
FILENAME = 'C:\SQLServer\MSSQL10_50.SQL2008R2\MSSQL\DATA\DW_FT_Data_03.ndf',
SIZE = 1024MB,
FILEGROWTH = 1MB)
TO FILEGROUP [DW_DATA_FT_FG]
go
ALTER DATABASE DW
ADD FILE
( NAME = DW_FT_Data_04,
FILENAME = 'C:\SQLServer\MSSQL10_50.SQL2008R2\MSSQL\DATA\DW_FT_Data_04.ndf',
SIZE = 1024MB,
FILEGROWTH = 1MB)
TO FILEGROUP [DW_DATA_FT_FG]
go