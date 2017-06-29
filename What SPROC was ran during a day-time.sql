---------------------------------
--Specific host calls and sprocs
----------------------------------
select distinct snq.object_name,acs.host_name,acs.program_name
----, COUNT(*)
--,DATEPART(Month, acs.collection_time) CMonth,DATEPART(Day, acs.collection_time)CDay,DATEPART(hour, acs.collection_time) CHour
-- ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
INNER JOIN snapshots.notable_query_text snq ON snq.sql_handle=acs.sql_handle
where acs.database_name='LodgingInventoryMaster09'
AND sii.instance_name = 'CHELSQLAAGAD001'
and collection_time BETWEEN  '2017-02-27 10:00:00.9230000 -08:00' AND '2017-02-27 13:00:00.9230000 -08:00'
--AND acs.host_name like 'CHEXSQMRMT2A001'
--GROUP BY acs.host_name,acs.program_name,DATEPART(Month, acs.collection_time) ,DATEPART(Day, acs.collection_time),DATEPART(hour, acs.collection_time) 
--ORDER BY 5 DESC,6 DESC