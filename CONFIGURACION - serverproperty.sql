SELECT SERVERPROPERTY ('edition') Edition,
SERVERPROPERTY ('BuildClrVersion') BuildClrVersion,
SERVERPROPERTY ('IsClustered') IsClustered,
SERVERPROPERTY ('ComputerNamePhysicalNetBIOS')  ComputerNamePhysicalNetBIOS,
SERVERPROPERTY ('MachineName') MachineName,
SERVERPROPERTY ('ProcessID') ProcessID,
SERVERPROPERTY ('ProductVersion') ProductVersion,
SERVERPROPERTY ('ProductLevel') ProductLevel,
SERVERPROPERTY ('ResourceVersion') ResourceVersion

SELECT
SERVERPROPERTY('ProductVersion') AS ProductVersion,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('Edition') AS Edition,
SERVERPROPERTY('EngineEdition') AS EngineEdition;
GO
 
