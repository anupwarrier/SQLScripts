--CREATE DATABASE MS_CDCMetadata 
GO 
 
USE <cdc_enabled_database>
GO 

--Queryname,is_cdc_enabled metadata to confirm DB is enabled
SELECT * 
INTO MS_CDCMetadata..CDCDatabases 
FROM sys.databases where name=db_name()

--Query jobs created by CDC
--exec sys.sp_cdc_help_jobs
select 
			j.job_id as job_id,
            j.job_type as job_type,
            s.name as job_name,
            j.maxtrans as maxtrans,
            j.maxscans as maxscans,
            j.continuous as continuous,
            j.pollinginterval as pollinginterval,
            j.retention as retention,
            j.threshold as threshold
INTO MS_CDCMetadata..CDC_JOBS
        from msdb.dbo.cdc_jobs j inner join msdb.dbo.sysjobs s
        on j.job_id = s.job_id
        where database_id = db_id()
go

--Query metadata for tables enabled
Select * 
INTO MS_CDCMetadata..CDCEnabledTables
from sys.tables 
where is_tracked_by_cdc = 1
go

--CDC creates multiple metadata tables with CDC schema name, here they are
Select ss.name + '.' + so.name as CDCObjectnames, so.* 
INTO MS_CDCMetadata..CDCMetadataTables
from sysobjects so join sys.schemas ss on so.uid=ss.schema_id where ss.name='cdc' and so.xtype='U'
go

--CDC Procedures
Select ss.name + '.' + so.name as CDCProcedurenames, so.* 
INTO MS_CDCMetadata..CDCProcedures
from sysobjects so join sys.schemas ss on so.uid=ss.schema_id where ss.name='cdc' and so.xtype='P'
go

--Stores information about "change" tables participating in CDC 
--Think of it as sysarticles table in Transactional Replication
Select object_name(object_id) as CT_TableName,* 
INTO MS_CDCMetadata..cdc_change_tables
from cdc.change_tables
go

--Stores information about the columns tracked per CDC Table
Select object_name(object_id) as CTTableName, * 
INTO MS_CDCMetadata..cdc_captured_columns
from cdc.captured_columns
go

--Stores information about index column in CDC Table
Select object_name(object_id) as CTTableName,* 
INTO MS_CDCMetadata..cdc_index_columns
from cdc.index_columns
go

--Stores information about any DDL changes (Alter Table) done to CDC Table
Select top 10000 * 
INTO MS_CDCMetadata..cdc_ddl_history
from cdc.ddl_history
order by ddl_time desc
go

--Parent table storing information for each transaction have associated change in change table.
--Think of it as msrepl_Transactions table in TReplication
--Records mapping between log sequence numbers (LSNs) and the date and time when the transaction happened
Select  * 
INTO MS_CDCMetadata..cdc_lsn_time_mapping
from cdc.lsn_time_mapping
order by tran_begin_time desc
go

--Notice 5 additonal columns __$start_lsn, __$end_lsn, __$seqval, __$operation, and __$update_mask in addition to actual table columns
--Child tables storing information about each DML operation corresponding to transaction in cdc.lsn_time_mapping table.
--Think of it as msrepl_Commands in TReplication
--Select * from cdc.dbo_test1_CT
--Select * from cdc.dbo_test2_CT

--stores one row for each log scan session in the current database. 
select  * 
INTO MS_CDCMetadata..dm_cdc_log_scan_sessions
from sys.dm_cdc_log_scan_sessions
order by start_time desc
go

--stores errors encountered during the change data capture log scan session
select  * 
INTO MS_CDCMetadata..dm_cdc_errors
from sys.dm_cdc_errors
order by entry_time desc
go


--Change backup location if needed. 
--BACKUP DATABASE MS_CDCMetadata TO DISK='c:\MS_CDCMetadata.bak' 
GO 
