select s.name AS [Schema Name], o.name AS [Table Name], i.name AS [Index Name], idstat.index_type_desc AS [Index Type], idstat.avg_fragmentation_in_percent AS [Fragmentation %] 
from sys.dm_db_index_physical_stats(DB_ID(), null, null, null,null) as idstat
inner join sys.indexes as i
on idstat.object_id =i.object_id and idstat.index_id = i.index_id
inner join sys.all_objects o
on idstat.object_id = o.object_id
inner join sys.schemas s
on o.schema_id = s.schema_id 
where idstat.alloc_unit_type_desc ='IN_ROW_DATA'  
order by s.name , o.name