/*
Potrebno je promeniti bazu podataka
Rezultati su grupisani po nazivu tabele 
-----------------------------------------
Change database
Results are grouped by table name
*/

/*
Korisceni sistemski objekti:
-----------------------------
Used system objects:
*/

--- SELECT * FROM sys.dm_db_partition_stats
-- SELECT * FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL)
---SELECT * FROM sys.tables
---SELECT * FROM sys.indexes
---SELECT * FROM sys.all_objects
---SELECT * FROM  sys.schemas


USE [AdventureWorks2014]
GO


SELECT s.[name] AS [Schema Name], tn.[name] AS [Table name], ix.[name] AS [Index name], ix.[type_desc] AS [Index type], ips.[avg_fragmentation_in_percent] AS [Avg Fragmentation in percent], 
SUM(sz.[used_page_count]) AS [Total pages per index],SUM(sz.[used_page_count]) * 8 AS [Index size (KB)],  CAST((ROUND((SUM(sz.[used_page_count]) * 8.0) / 1024,2)) as DECIMAL(5, 2))  AS [Index size (MB)]
FROM sys.dm_db_partition_stats AS sz
INNER JOIN sys.indexes AS ix ON sz.[object_id] = ix.[object_id] 
AND sz.[index_id] = ix.[index_id]
INNER JOIN sys.tables tn ON tn.OBJECT_ID = ix.object_id
INNER JOIN sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ips ON ips.object_id = ix.object_id
INNER JOIN sys.all_objects AS ao ON ao.object_id = ips.object_id
INNER JOIN sys.schemas AS s ON ao.schema_id = s.schema_id 
GROUP BY tn.[name], ix.[name], ix.[type_desc], ips.[avg_fragmentation_in_percent], s.[name]
ORDER BY tn.[name]



