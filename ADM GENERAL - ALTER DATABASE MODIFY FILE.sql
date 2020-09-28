ALTER DATABASE MyDatabase SET OFFLINE;

--move log file to E drive manually and attach from new location

ALTER DATABASE MyDatabase

      MODIFY FILE (

            NAME='MyDatabase_Log', 

            FILENAME='E:\LogFiles\MyDatabase_Log.ldf');

ALTER DATABASE MyDatabase SET ONLINE;
