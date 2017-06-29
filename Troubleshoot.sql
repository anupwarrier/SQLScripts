USE EXPEDBA
GO
SELECT * FROM [mon].[ActiveSpids]
WHERE MyTimeStamp between '2016-09-08 14:00' and '2016-09-08 18:00'


USE AG_Analytics
GO
SELECT replica_server_name,database_name,synchronization_state_desc,synchronization_health_desc,last_sent_time,last_sent_time
last_redone_time,log_send_queue_size,redo_queue_size FROM [dbo].[KeyStats]
WHERE database_name = 'LodgingInventoryMaster09'

DBCC SQLPERF(logspace)

DBCC loginfo

SELECT * FROM sys.dm_hadr_availability_replica_states

SELECT log_reuse_wait_desc FROM sys.databases 
where name = 'LodgingInventoryMaster09'

SELECT * FROM cdc.lsn_time_mapping
WHERE tran_begin_time > '2016-07-29'

select * from sys.dm_cdc_log_scan_sessions

Select * from msdb..cdc_jobs

BEGIN TRAN
UPDATE msdb..cdc_jobs
SET maxtrans = '5000'
WHERE job_type = 'capture'
COMMIT TRAN

BEGIN TRAN
UPDATE msdb..cdc_jobs
SET pollinginterval = '1'
WHERE job_type = 'capture'
COMMIT TRAN


--Repl Done
EXEC sp_repldone @xactid = NULL, @xact_segno = NULL, @numtrans = 0,     @time = 0, @reset = 1   

DBCC SHRINKFILE('LodgingInventory_Log')

--Backup

BACKUP DATABASE [LodgingInventoryMaster09]
TO DISK = N'P:\BAK\LodgingInventoryMaster09_CleanFull.bak'
WITH COMPRESSION,STATS=5;

--Truncate AG
USE [AG_Analytics]
GO
TRUNCATE TABLE [dbo].[KeyStats]

--Check Hosts
select * from sys.dm_exec_sessions
where session_id >50
order by host_name

--DBCC DROPCLEANBUFFERS

--DBCC FREESYSTEMCACHE ('ALL')


sp_who2 'Active'

SELECT  spid,
        sp.[status],
        loginame [Login],
        hostname, 
        blocked BlkBy,
        sd.name DBName, 
        cmd Command,
        cpu CPUTime,
        physical_io DiskIO,
        last_batch LastBatch,
        [program_name] ProgramName   
FROM master.dbo.sysprocesses sp 
JOIN master.dbo.sysdatabases sd ON sp.dbid = sd.dbid
ORDER BY spid 


sp_helpdb [LodgingInventoryMaster09]


sp_readerrorlog

sp_cycle_errorlog


--CDC time 2016-12-12 14:13:28.360


