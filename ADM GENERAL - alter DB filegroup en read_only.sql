ALTER DATABASE [Repositorio_Marketing] SET SINGLE_USER WITH rollback immediate

ALTER DATABASE Repositorio_Marketing
MODIFY FILEGROUP [DATA07] READ_ONLY ;
GO

ALTER DATABASE [Repositorio_Marketing] SET MULTI_USER WITH NO_WAIT