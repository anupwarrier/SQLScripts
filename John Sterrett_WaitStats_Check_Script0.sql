/***************************************************************************
	Author : John Sterrett, Procure SQL LLC

	File:     WaitStats.sql

	Summary:  This script leverages sys.dm_os_wait_stats and runs twice with 
			  a wait specified by @WaitSeconds in between. These two captures 
			  are then compaired and then saved.	

	Parameter: @WaitSeconds int - is used to wait between captures to compare.

	Date:	  October 2013

	Version:  SQL 2005+ 
  

  ---------------------------------------------------------------------------
  
  For more scripts and sample code, check out 
    http://www.johnsterrett.com

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.

  Other related links:
 http://technet.microsoft.com/library/Cc966413

	Further Reading (Not By Me):
http://www.sqlskills.com/blogs/paul/wait-statistics-or-please-tell-me-where-it-hurts/
http://blogs.msdn.com/b/psssql/archive/2009/11/03/the-sql-server-wait-type-repository.aspx
https://www.simple-talk.com/sql/database-administration/a-first-look-at-sql-server-2012-availability-group-wait-statistics/

************************************************************************/


	 


If NOT EXISTS (Select 1 from sys.schemas where name = N'Waits')
		execute sp_executesql @stmt = N'CREATE SCHEMA [Waits] AUTHORIZATION [dbo];'



CREATE TABLE Waits.WaitStats (CaptureDataID bigint, WaitType varchar(200), wait_S decimal(20,5), Resource_S decimal (20,5), Signal_S decimal (20,5), WaitCount bigint, Avg_Wait_S numeric(10, 6), Avg_Resource_S numeric(10, 6),Avg_Signal_S numeric(10, 6), CaptureDate datetime)
CREATE TABLE Waits.BenignWaits (WaitType varchar(200))
CREATE TABLE Waits.CaptureData (
ID bigint identity PRIMARY KEY,
StartTime datetime,
EndTime datetime,
ServerName varchar(500),
PullPeriod int
)

INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('CLR_SEMAPHORE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('LAZYWRITER_SLEEP')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES  ('RESOURCE_QUEUE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SLEEP_TASK')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SLEEP_SYSTEMTASK')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SQLTRACE_BUFFER_FLUSH')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES  ('WAITFOR')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('LOGMGR_QUEUE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('CHECKPOINT_QUEUE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('REQUEST_FOR_DEADLOCK_SEARCH')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('XE_TIMER_EVENT')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES  ('BROKER_TO_FLUSH')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('BROKER_TASK_STOP')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('CLR_MANUAL_EVENT')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('CLR_AUTO_EVENT')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('DISPATCHER_QUEUE_SEMAPHORE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('FT_IFTS_SCHEDULER_IDLE_WAIT')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('XE_DISPATCHER_WAIT')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('XE_DISPATCHER_JOIN')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('BROKER_EVENTHANDLER')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('TRACEWRITE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('FT_IFTSHC_MUTEX')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SQLTRACE_INCREMENTAL_FLUSH_SLEEP')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('BROKER_RECEIVE_WAITFOR')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('ONDEMAND_TASK_QUEUE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('DBMIRROR_EVENTS_QUEUE')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('DBMIRRORING_CMD')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('BROKER_TRANSMITTER')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SQLTRACE_WAIT_ENTRIES')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SLEEP_BPOOL_FLUSH')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SQLTRACE_LOCK')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('DIRTY_PAGE_POLL')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('SP_SERVER_DIAGNOSTICS_SLEEP')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('HADR_FILESTREAM_IOMGR_IOCOMPLETION')
INSERT INTO Waits.BenignWaits (WaitType)
VALUES ('HADR_WORK_QUEUE')

insert Waits.BenignWaits (WaitType) VALUES ('QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP');
insert Waits.BenignWaits (WaitType) VALUES ('QDS_PERSIST_TASK_MAIN_LOOP_SLEEP');
GO

--DROP PROCEDURE Waits.GetWaitStats
CREATE PROCEDURE Waits.GetWaitStats 
	@WaitTimeSec INT = 60,
	@StopTime DATETIME = NULL
AS
BEGIN
	DECLARE @CaptureDataID int
	/* Create temp tables to capture wait stats to compare */
	IF OBJECT_ID('tempdb..#WaitStatsBench') IS NOT NULL
		DROP TABLE #WaitStatsBench
	IF OBJECT_ID('tempdb..#WaitStatsFinal') IS NOT NULL
		DROP TABLE #WaitStatsFinal

	CREATE TABLE #WaitStatsBench (WaitType varchar(200), wait_S decimal(20,5), Resource_S decimal (20,5), Signal_S decimal (20,5), WaitCount bigint)
	CREATE TABLE #WaitStatsFinal (WaitType varchar(200), wait_S decimal(20,5), Resource_S decimal (20,5), Signal_S decimal (20,5), WaitCount bigint)

	DECLARE @ServerName varchar(300)
	SELECT @ServerName = convert(nvarchar(128), serverproperty('servername'))
	
	/* Insert master record for capture data */
	INSERT INTO Waits.CaptureData (StartTime, EndTime, ServerName,PullPeriod)
	VALUES (GETDATE(), NULL, @ServerName, @WaitTimeSec)
	
	SELECT @CaptureDataID = SCOPE_IDENTITY()
	 
/* Loop through until time expires  */
	IF @StopTime IS NULL
		SET @StopTime = DATEADD(hh, 1, getdate())
	WHILE GETDATE() < @StopTime
	BEGIN

		/* Get baseline */
		
		INSERT INTO #WaitStatsBench (WaitType, wait_S, Resource_S, Signal_S, WaitCount)
		SELECT
				wait_type,
				wait_time_ms / 1000.0 AS WaitS,
				(wait_time_ms - signal_wait_time_ms) / 1000.0 AS ResourceS,
				signal_wait_time_ms / 1000.0 AS SignalS,
				waiting_tasks_count AS WaitCount
			FROM sys.dm_os_wait_stats
			WHERE wait_time_ms > 0.01 
			AND wait_type NOT IN ( SELECT WaitType FROM Waits.BenignWaits)
		

		/* Wait a few minutes and get final snapshot */
		WAITFOR DELAY @WaitTimeSec;

		INSERT INTO #WaitStatsFinal (WaitType, wait_S, Resource_S, Signal_S, WaitCount)
		SELECT
				wait_type,
				wait_time_ms / 1000.0 AS WaitS,
				(wait_time_ms - signal_wait_time_ms) / 1000.0 AS ResourceS,
				signal_wait_time_ms / 1000.0 AS SignalS,
				waiting_tasks_count AS WaitCount
			FROM sys.dm_os_wait_stats
			WHERE wait_time_ms > 0.01
			AND wait_type NOT IN ( SELECT WaitType FROM Waits.BenignWaits)
		
		DECLARE @CaptureTime datetime 
		SET @CaptureTime = getdate()

		INSERT INTO Waits.WaitStats (CaptureDataID, WaitType, Wait_S, Resource_S, Signal_S, WaitCount, Avg_Wait_S, Avg_Resource_S,Avg_Signal_S, CaptureDate)
		SELECT  @CaptureDataID,
		    f.WaitType,
			f.wait_S - b.wait_S as Wait_S,
			f.Resource_S - b.Resource_S as Resource_S,
			f.Signal_S - b.Signal_S as Signal_S,
			f.WaitCount - b.WaitCount as WaitCounts,
			CAST(CASE WHEN f.WaitCount - b.WaitCount = 0 THEN 0 ELSE (f.wait_S - b.wait_S) / (f.WaitCount - b.WaitCount) END AS numeric(10, 6))AS Avg_Wait_S,
			CAST(CASE WHEN f.WaitCount - b.WaitCount = 0 THEN 0 ELSE (f.Resource_S - b.Resource_S) / (f.WaitCount - b.WaitCount) END AS numeric(10, 6))AS Avg_Resource_S,
			CAST(CASE WHEN f.WaitCount - b.WaitCount = 0 THEN 0 ELSE (f.Signal_S - b.Signal_S) / (f.WaitCount - b.WaitCount) END AS numeric(10, 6))AS Avg_Signal_S,
			@CaptureTime
		FROM #WaitStatsFinal f
		LEFT JOIN #WaitStatsBench b ON (f.WaitType = b.WaitType)
		WHERE (f.wait_S - b.wait_S) > 0.0 -- Added to not record zero waits in a time interval.
		
		TRUNCATE TABLE #WaitStatsBench
		TRUNCATE TABLE #WaitStatsFinal
 END -- END of WHILE
 
 /* Update Capture Data meta-data to include end time */
 UPDATE Waits.CaptureData
 SET EndTime = GETDATE()
 WHERE ID = @CaptureDataID
END