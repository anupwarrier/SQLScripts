--Overview of all DBs
exec EXPEDBA.dbo.dba_Dashboard

--Current blocking with head blocker, commands and objects involved in blocking chain shown
exec EXPEDBA.dbo.aba_lockinfo

--Current processes with query plan
exec EXPEDBA.dbo.spWhatsHappening

--Current processes, good at tempdb allocations
exec master.dbo.sp_WhoIsActive

--Active waits table - I will create spWaitSnapshot at some point
select wait_type,sum(wait_duration_ms)
from EXPEDBA.dbo.active_waits
where mytimestamp between dateadd(minute,-30,getdate()) and GETDATE()
group by wait_type

select *
from EXPEDBA.dbo.active_waits
where mytimestamp between '2016-12-15 08:22:37' and '2016-12-15 08:25:37'


--Recent alerts
SELECT 
convert(smalldatetime, MyTimeStamp) as MyTimeStamp
, EventDesc
, ErrorLevel
, replace(MsgDetail, ', Check dbo.dba_dm_os_waiting_tasks for details.', '') AS MsgDetail
FROM EXPEDBA.evt.EventHist H
JOIN EXPEDBA.evt.EventType T
ON T.EventID = H.EventID
ORDER BY mytimestamp DESC


--Free space in drives
exec EXPEDBA.dbo.spDriveFreeSpace

--Snapshot of sproc activity in the past 15 minutes
exec EXPEDBA.dbo.SpSprocSnapshot
      @order_by     = 1 --1=Duration, 2=CPU, 3=IO, 4=Count, 5=Avg duration
      , @database       = null      --Null for default (All)
      , @end_date     = null  --Null for default (getdate())
      , @top          = 5     --Top N, mainly for use with CMS grouped results

--3 days of sproc performance
exec EXPEDBA.dbo.spSprocHistory     
      @database         = 'OrderMaster_01'      --DB to look at
      , @object         = 'ORDER_LINES_SAVE'     --Object to show
      , @cmd_no         = 1              --Filter by individual cmd          default = all
      , @end_date       = null            --Last date to look at              default = getdate()
      , @show_header    = 1               --Show query plan etc, faster without for copy\paste operation
      , @grouped        = 0              --Group all results and show total for sproc



EXECUTE  [ExpedbaHist].[dbo].[spSprocHistoryHist] 
      @server        = 'CHEXSQMMFEWE001\EWE001'
      , @database      = 'BaggageFee'
      , @object        = 'BaggageFeeGet'
      , @cmd_no        = 1
      , @start_date    = '2013-03-25'
      , @end_date      = '2013-03-27'
      , @grouped       = 0



SELECT
    [sch].[name] + '.' + [so].[name] AS [TableName],
    [ss].[name] AS [Statistic],
    [ss].[auto_Created] AS [WasAutoCreated],
    [ss].[user_created] AS [WasUserCreated],
    [ss].[has_filter] AS [IsFiltered], 
    [ss].[filter_definition] AS [FilterDefinition], 
    --[ss].[is_temporary] AS [IsTemporary],
    [sp].[last_updated] AS [StatsLastUpdated], 
    [sp].[rows] AS [RowsInTable], 
    [sp].[rows_sampled] AS [RowsSampled], 
    [sp].[unfiltered_rows] AS [UnfilteredRows],
    [sp].[modification_counter] AS [RowModifications],
    [sp].[steps] AS [HistogramSteps],
    CAST(100 * [sp].[modification_counter] / [sp].[rows]
                            AS DECIMAL(18,2)) AS [PercentChange]
FROM [sys].[stats] [ss]
JOIN [sys].[objects] [so] ON [ss].[object_id] = [so].[object_id]
JOIN [sys].[schemas] [sch] ON [so].[schema_id] = [sch].[schema_id]
OUTER APPLY [sys].[dm_db_stats_properties]
                    ([so].[object_id], [ss].[stats_id]) sp
WHERE [so].[type] = 'U' and so.name = 'ChangeRequest'
--AND CAST(100 * [sp].[modification_counter] / [sp].[rows]
--                                        AS DECIMAL(18,2)) >= 10.00
ORDER BY CAST(100 * [sp].[modification_counter] / [sp].[rows]
                                        AS DECIMAL(18,2)) DESC;



SELECT OBJECT_SCHEMA_NAME(object_id), OBJECT_NAME(object_id) 
FROM sys.partitions 
WHERE hobt_id IN (72057594040614912);