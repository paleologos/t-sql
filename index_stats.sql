---STATISTIKA INDEXA PO TABELAMA   -  INDEX STATISTICS BY TABLE
---PRE POKRETANJA PROMENITI BAZU PODATAKA - BEFORE EXECUTING CHANGE THE DATABASE    


use [AdventureWorks2014]
go

select distinct s.name AS [Schema Name], o.name AS [Table Name],o.object_id as [Object ID], i.name AS [Index Name], idstat.index_type_desc AS [Index Type],
idstat.avg_fragmentation_in_percent AS [Fragmentation %],idstat.page_count AS [Index size - Page],idstat.page_count *8 AS [Index size - kB], ROUND(idstat.page_count *8.0/1024,4,1) AS [Index size - MB]

from sys.dm_db_index_physical_stats(DB_ID(), null, null, null,null) as idstat
inner join sys.indexes as i
on idstat.object_id =i.object_id and idstat.index_id = i.index_id
inner join sys.all_objects o
on idstat.object_id = o.object_id
inner join sys.schemas s
on o.schema_id = s.schema_id 
inner join  sys.partitions as p
on o.object_id = p.object_id
inner join sys.allocation_units as au
on p.hobt_id = au.container_id

where idstat.alloc_unit_type_desc ='IN_ROW_DATA' 

GROUP BY s.name,o.name, i.name, idstat.index_type_desc, idstat.avg_fragmentation_in_percent, o.object_id,idstat.page_count
order by s.name , o.name
