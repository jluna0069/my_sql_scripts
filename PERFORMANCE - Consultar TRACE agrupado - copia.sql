use sysdba
go
SELECT  
     CASE
 WHEN EventClass = 10 THEN 'RPC:Completed'
 WHEN EventClass = 12 THEN 'SQL:BatchCompleted' 
 WHEN EventClass = 45 THEN 'SP:StmtCompleted'  
 WHEN EventClass = 43 THEN 'SP:Completed' 
 WHEN EventClass = 41 THEN 'SQL:StmtCompleted'
 ELSE 'NN'
      END
 , CAST(TextData as nvarchar(2000)) as TEXT
 ,COUNT(*) AS TotalExecutions
 ,((SUM(Duration))/1000000) AS DurationTotal

 ,Hostname AS Host
 ,SessionLoginName AS Usuario
FROM dbo.TRACE_SPs_20150407_40MIN
WHERE [TextData] LIKE '%TotalizarGastos_Especie%'
GROUP BY EventClass, CAST(TextData as nvarchar(2000)), Hostname, SessionLoginName
ORDER BY DurationTotal DESC,TotalExecutions DESC