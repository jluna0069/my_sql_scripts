USE C24
go

CREATE USER c24 FOR LOGIN c24
WITH DEFAULT_SCHEMA = c24
go
EXEC sp_addrolemember 'db_owner', 'c24'
go
IF USER_ID('c24') IS NOT NULL
    PRINT '<<< CREATED USER c24 >>>'
ELSE
    PRINT '<<< FAILED CREATING USER c24 >>>'
go

CREATE USER dbo FOR LOGIN [EDESUR\jjservetti]
WITH DEFAULT_SCHEMA = dbo
go
EXEC sp_addrolemember 'db_owner', 'dbo'
go

CREATE USER guest WITHOUT LOGIN
WITH DEFAULT_SCHEMA = guest
go
IF USER_ID('guest') IS NOT NULL
    PRINT '<<< CREATED USER guest >>>'
ELSE
    PRINT '<<< FAILED CREATING USER guest >>>'
go
GRANT CONNECT TO c24
go
GRANT CONNECT TO dbo
go
