USE master; 

GO 

CREATE ENDPOINT BrokerEndpoint 

    STATE = STARTED 

    AS TCP ( LISTENER_PORT = 4037 ) 

    FOR SERVICE_BROKER ( AUTHENTICATION = WINDOWS ) ; 

GO 

ALTER DATABASE OperationsManager SET ENABLE_BROKER 
go

 
