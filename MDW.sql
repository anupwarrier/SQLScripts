select  DATEADD(dd, 0, DATEDIFF(dd, 0, collection_time)) Date,COUNT(*) ConnectionCount
from snapshots.active_sessions_and_requests 
where database_name='Atlas'
GROUP BY  DATEADD(dd, 0, DATEDIFF(dd, 0, collection_time))
Order BY 1

-- To find Connections
select  sii.instance_name ServerName,DATEADD(dd, 0, DATEDIFF(dd, 0, acs.collection_time)) Date ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
where acs.database_name='Atlas'
AND sii.instance_name like 'CHEXSQLATL%'
GROUP BY  sii.instance_name, DATEADD(dd, 0, DATEDIFF(dd, 0, collection_time))
Order BY 1,2


--Date	ConnectionCount
--2013-02-12 00:00:00.000	347
--347
select   DATEADD(dd, 0, DATEDIFF(dd, 0, collection_time)) Date,COUNT(*) ConnectionCount
from snapshots.active_sessions_and_requests 
where database_name='PaymentVault'
and collection_time BETWEEN  '2013-02-12 11:00:00.9230000 -08:00' AND '2013-02-12 12:00:00.9230000 -08:00'
GROUP BY  DATEADD(dd, 0, DATEDIFF(dd, 0, collection_time))
Order BY 1


-- To find Connections hourly
select  sii.instance_name ServerName,CONVERT(DATETIME,DATEDIFF(hh, 0, acs.collection_time)) Date ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
where acs.database_name='AirConfiguration'
AND sii.instance_name like 'CHEXSQMRMT2A001\T2A001'
and collection_time BETWEEN  '2014-01-20 18:00:00.9230000 -00:00' AND '2014-01-20 18:30:00.9230000 -08:00'
GROUP BY  sii.instance_name,DATEDIFF(hh, 0, acs.collection_time) 
Order BY 1,2

-------------------------
----updated
-----------------------
-- To find Connections hourly
select  sii.instance_name ServerName,DATEPART(Month, acs.collection_time) CMonth,DATEPART(Day, acs.collection_time)CDay,DATEPART(hour, acs.collection_time) CHour ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
where acs.database_name='LodgingCatalog'
AND sii.instance_name like 'CHEXSQLLCS004%'
and collection_time BETWEEN  '2013-03-14 00:00:00.9230000 -08:00' AND '2013-03-14 15:00:00.9230000 -08:00'
GROUP BY  sii.instance_name,DATEPART(Month, acs.collection_time),DATEPART(Day, acs.collection_time),DATEPART(hour, acs.collection_time)
Order BY 1,2


-- To find Connections hourly
select  sii.instance_name ServerName,acs.host_name,
DATEPART(Month, acs.collection_time) CMonth,DATEPART(Day, acs.collection_time)CDay,DATEPART(hour, acs.collection_time) CHour ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
where acs.database_name='LodgingCatalog'
AND sii.instance_name like 'CHEXSQLLCS002%'
and collection_time BETWEEN  '2013-03-14 00:00:00.9230000 -08:00' AND '2013-03-14 15:00:00.9230000 -08:00'
GROUP BY  sii.instance_name,host_name, DATEPART(Month, acs.collection_time),DATEPART(Day, acs.collection_time),DATEPART(hour, acs.collection_time)
Order BY 6 desc



---To find DB growth trend... 


SELECT
    c.instance_name
  , a.dbsize / 128 AS 'DBSizeMB'
  , a.logsize
  , a.ftsize
  , a.database_name
  , convert(datetime,a.collection_time,102)
FROM
    MDW.snapshots.disk_usage a INNER JOIN
    MDW.core.snapshots_internal b
    ON a.snapshot_id = b.snapshot_id INNER JOIN
    MDW.core.source_info_internal c
    ON b.source_id = c.source_id
WHERE
	a.database_name='Airlog'
ORDER BY
    c.instance_name
  , a.database_name
  , a.collection_time ASC
  ---------------------------
  

SELECT
    c.instance_name
  , a.dbsize / 128 AS 'DBSizeMB'
  , a.logsize / 128 AS 'LogSizeMB'
  , a.ftsize
  , a.database_name
  , convert(datetime,a.collection_time,102)
  ,a.reservedpages / 128 AS 'RpageMB'
  ,a.usedpages / 128 AS 'UsedpagesMB'
  ,a.pages / 128 AS 'PagesMB'
FROM
    MDW.snapshots.disk_usage a INNER JOIN
    MDW.core.snapshots_internal b
    ON a.snapshot_id = b.snapshot_id INNER JOIN
    MDW.core.source_info_internal c
    ON b.source_id = c.source_id
WHERE
	a.database_name='TL_Reports'
ORDER BY
  --  c.instance_name
  --, a.database_name
   a.collection_time DESC
  
  ---------------------------------
  --Check connections count and Query for a period
  --------------------------------------------
  
  
SELECT ar.database_name,ar.login_time,ar.host_name,ar.program_name,ar.request_start_time,nq.sql_text
  FROM [MDW].[snapshots].[active_sessions_and_requests] ar
  inner join snapshots.notable_query_text nq
		on ar.sql_handle=nq.sql_handle 
  WHERE database_name='OrderMaster_01'
  AND nq.sql_text like '%ORDER_RECONSTRUCT#03%'
  and ar.request_start_time>'2013-03-04 00:00:19.513'

SELECT ar.host_name,COUNT(*) NoofConns
  FROM [MDW].[snapshots].[active_sessions_and_requests] ar
  inner join snapshots.notable_query_text nq
		on ar.sql_handle=nq.sql_handle 
  WHERE database_name='OrderMaster_01'
  AND nq.sql_text like '%ORDER_RECONSTRUCT#03%'
  and ar.request_start_time>'2013-03-04 00:00:19.513'
GROUP BY ar.host_name
order by 2 desc 


---------------------------------
--Hourly Host connections
----------------------------------
select  acs.host_name,acs.program_name, COUNT(*)
,DATEPART(Month, acs.collection_time) CMonth,DATEPART(Day, acs.collection_time)CDay,DATEPART(hour, acs.collection_time) CHour
-- ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
where acs.database_name='LodgingCatalogmaster'
AND sii.instance_name = 'CHEXSQMMJLCM001\LCM001'
and collection_time BETWEEN  '2013-04-03 19:00:00.9230000 -08:00' AND '2013-04-10 15:00:00.9230000 -08:00'
--AND acs.host_name='CHE-LSSBIZ03'
GROUP BY acs.host_name,acs.program_name,DATEPART(Month, acs.collection_time) ,DATEPART(Day, acs.collection_time),DATEPART(hour, acs.collection_time) 
ORDER BY 5 DESC,6 DESC

---------------------------------
--Specific host calls and sprocs
----------------------------------
select  top 1000 acs.host_name,acs.program_name
,*
--, COUNT(*)
,DATEPART(Month, acs.collection_time) CMonth,DATEPART(Day, acs.collection_time)CDay,DATEPART(hour, acs.collection_time) CHour
-- ,COUNT(*) ConsCount
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
INNER JOIN snapshots.notable_query_text snq ON snq.sql_handle=acs.sql_handle
where acs.database_name='Airconfiguration'
AND sii.instance_name = 'CHEXSQMRMT2A001\T2A001'
and collection_time BETWEEN  '2014-01-20 18:05:00.9230000 -08:00' AND '2014-01-20 18:20:00.9230000 -08:00'
AND acs.host_name like 'CHEXSQMRMT2A001'
--GROUP BY acs.host_name,acs.program_name,DATEPART(Month, acs.collection_time) ,DATEPART(Day, acs.collection_time),DATEPART(hour, acs.collection_time) 
--ORDER BY 5 DESC,6 DESC

SELECT
Host_name, program_name, database_name, login_name, session_last_request_start_time,session_last_request_end_time, command, object_id, object_name, substring(sql_text, 1, 50)
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
INNER JOIN snapshots.notable_query_text snq ON snq.sql_handle=acs.sql_handle
where acs.database_name='EventPublisher_01'
AND sii.instance_name = 'CHEXSQMNKOMS007\OMS007'
--and collection_time BETWEEN  '2013-04-03 19:00:00.9230000 -08:00' AND '2013-04-10 15:00:00.9230000 -08:00'
AND acs.host_name like 'CHEXJVA%'

--- With DISTINCT filter
SELECT
DISTINCT Host_name, program_name, database_name, login_name,  command, object_id, object_name, substring(sql_text, 1, 50) Sproc
from snapshots.active_sessions_and_requests acs
INNER JOIN core.snapshots_internal si ON acs.snapshot_id=si.snapshot_id
INNER JOIN core.source_info_internal sii ON sii.source_id=si.source_id
INNER JOIN snapshots.notable_query_text snq ON snq.sql_handle=acs.sql_handle
where acs.database_name='OrderSearch'
AND sii.instance_name = 'CHEXSQLOSS004'
--and collection_time BETWEEN  '2013-04-03 19:00:00.9230000 -08:00' AND '2013-04-10 15:00:00.9230000 -08:00'
AND acs.host_name like 'CHEXJVA%'
AND object_name IS NOT NULL





------------------
USE MDW
select count(instance_name) MDW  from core.source_info_internal

USE MDW2

select count(instance_name) MDW2  from core.source_info_internal
