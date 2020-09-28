--How to View Transaction Log in SQL Server 
--Monday, April 27, 2009 Posted by Suprotim Agarwal 
--Labels: SQL Server Administration  


  
DBCC log ( dbname, 0|1|2|3|4 )

--where 

--0: minimum information (Default)
--1: Returns info available using 0 + flags, tags and the log record length.
--2: Returns info available using 1 + object, index, page ID and slot ID.
--3: Maximum information about each operation.
--4: Maximum information about each operation + hexadecimal dump of the current transaction log row
-- In order to run this command against a database called 'PictureAlbum'





