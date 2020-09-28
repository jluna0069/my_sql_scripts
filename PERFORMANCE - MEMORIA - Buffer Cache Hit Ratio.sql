/*If you look at the first two lines, you can see that there is first a cntr_type of "537003264", 
which has a name of "Buffer cache hit ratio" and then in the second line there is a cntr_type of "1073939712" 
with a name of "Buffer cache hit ratio base". These two types of counters have to be used in conjunction with each 
other to determine the actual buffer cache hit ratio performance measurement. In the example output above, 
I show the buffer cache hit ratio counter pairing. There are many pairings of a counter with a base when you look at 
all the performance counters exposed by the sys.dm_os_performance_counters DMV. To calculate the real counter value, 
or in my case the buffer cache hit ratio you need to take the cntr_value "1055" of the counter_name "Buffer cache hit ratio" 
and divide it by the "Buffer cache hit ratio base" counter_value, which in this case is also "1055" and then multiple by 100.
Here is an example that does that in a single statement*/

SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 [BufferCacheHitRatio]
FROM (SELECT * FROM sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio'
AND object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) +
':Buffer Manager' END ) a
CROSS JOIN
(SELECT * from sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio base'
and object_name = CASE WHEN @@SERVICENAME = 'MSSQLSERVER'
THEN 'SQLServer:Buffer Manager'
ELSE 'MSSQL$' + rtrim(@@SERVICENAME) +
':Buffer Manager' END ) b;