*******DAG Build********

--Backup DBs(Source)

BACKUP DATABASE  [LodgingInventoryMaster09]
   TO DISK = 'P:\Backup1\LodgingInventoryMaster09_DAG.bak' 
   WITH COMPRESSION,STATS=5
GO 
BACKUP LOG  [LodgingInventoryMaster09]
   TO DISK = 'P:\Backup1\LodgingInventoryMaster09_DAG.trn' 
   WITH COMPRESSION,STATS=5
GO 

--Restore DBs(AWS/Azure Side)

USE [master]
RESTORE DATABASE [LodgingInventoryMaster09] 
FROM  DISK = N'F:\LodgingInventoryMaster09_DAG.bak' WITH  FILE = 1,  
MOVE N'LodgingInventory_sys' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_sys.ndf',  
MOVE N'LodgingInventory_data' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_data.mdf',  
MOVE N'LodgingInventory_Data2' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_Data2.ndf',  
MOVE N'LodgingInventory_Data3' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_Data3.ndf',  
MOVE N'LodgingInventory_Data4' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_Data4.ndf',  
MOVE N'LodgingInventory_CDC' TO N'E:\Data01\LodgingInventoryMaster09_LodgingInventory_CDC.ndf',  
MOVE N'LodgingInventory_Log' TO N'F:\Log01\LodgingInventoryMaster09_LodgingInventory_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5
GO

RESTORE LOG [LodgingInventoryMaster09] FROM  DISK = N'F:\LodgingInventoryMaster09_DAG.trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
GO

--Create AG at the AWS/Azure side without adding the DBs.

CREATE AVAILABILITY GROUP [LIMAZUREAG]   
FOR   
REPLICA ON N'ZCELSQLCLSTR001' WITH (ENDPOINT_URL = N'TCP://ZCELSQLCLSTR001:5022',   
    FAILOVER_MODE = MANUAL,   
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,   
    BACKUP_PRIORITY = 50,   
    SECONDARY_ROLE(ALLOW_CONNECTIONS = NO),   
    SEEDING_MODE = MANUAL),   
N'ZCELSQLCLSTR002' WITH (ENDPOINT_URL = N'TCP://ZCELSQLCLSTR002:5022',   
    FAILOVER_MODE = MANUAL,   
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,   
    BACKUP_PRIORITY = 50,   
    SECONDARY_ROLE(ALLOW_CONNECTIONS = NO),   
    SEEDING_MODE = MANUAL);   
GO  

--Create DAG,CH Side

CREATE AVAILABILITY GROUP [distributedag]  
WITH (DISTRIBUTED)   
AVAILABILITY GROUP ON  
'EXELSQAAG' WITH    
(   
LISTENER_URL = 'tcp://EXELSQAADDBA001:5022',    
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
),   
'LIMAZUREAG' WITH    
(   
LISTENER_URL = 'tcp://AZURELIS1:5022',   
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
);    
GO  

--Build DAG, AWS/Azure Side

ALTER AVAILABILITY GROUP [distributedag]   
JOIN   
AVAILABILITY GROUP ON  
'EXELSQAAG' WITH    
(   
LISTENER_URL = 'tcp://EXELSQAADDBA001:5022',    
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
),   
'LIMAZUREAG' WITH    
(   
LISTENER_URL = 'tcp://AZURELIS1:5022',   
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
);    
GO  

--Join the DBs at the AWS/Azure side

ALTER DATABASE [LodgingInventoryMaster09] SET HADR AVAILABILITY GROUP = LIMAZUREAG


