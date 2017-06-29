USE [master]
RESTORE DATABASE [LodgingInventoryMaster09] 
FROM  DISK = N'P:\BAK\LodgingInventoryMaster09.bak' WITH  FILE = 1,  
MOVE N'LodgingInventory_sys' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_sys.ndf',  
MOVE N'LodgingInventory_data' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_data.mdf',  
MOVE N'LodgingInventory_Data2' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data2.ndf',  
MOVE N'LodgingInventory_Data3' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data3.ndf',  
MOVE N'LodgingInventory_Data4' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data4.ndf',  
MOVE N'LodgingInventory_CDC' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_CDC.ndf',  
MOVE N'LodgingInventory_Log' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Log.ldf',  
NOUNLOAD,  STATS = 5
GO

--CH002
USE [master]
RESTORE DATABASE [LodgingInventoryMaster09] 
FROM  DISK = N'\\Chelsqlaagad001\p$\BAK\LodgingInventoryMaster09.bak' WITH  FILE = 1,  
MOVE N'LodgingInventory_sys' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_sys.ndf',  
MOVE N'LodgingInventory_data' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_data.mdf',  
MOVE N'LodgingInventory_Data2' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data2.ndf',  
MOVE N'LodgingInventory_Data3' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data3.ndf',  
MOVE N'LodgingInventory_Data4' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data4.ndf',  
MOVE N'LodgingInventory_CDC' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_CDC.ndf',  
MOVE N'LodgingInventory_Log' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Log.ldf',  
NOUNLOAD,  STATS = 5,NORECOVERY
GO

--PH001
USE [master]
RESTORE DATABASE [LodgingInventoryMaster09] 
FROM  DISK = N'\\Chelsqlaagad001\p$\BAK\LodgingInventoryMaster09.bak' WITH  FILE = 1,  
MOVE N'LodgingInventory_sys' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_sys.ndf',  
MOVE N'LodgingInventory_data' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_data.mdf',  
MOVE N'LodgingInventory_Data2' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data2.ndf',  
MOVE N'LodgingInventory_Data3' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data3.ndf',  
MOVE N'LodgingInventory_Data4' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data4.ndf',  
MOVE N'LodgingInventory_CDC' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_CDC.ndf',  
MOVE N'LodgingInventory_Log' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Log.ldf',  
NOUNLOAD,  STATS = 5,NORECOVERY
GO

--PH002
USE [master]
RESTORE DATABASE [LodgingInventoryMaster09] 
FROM  DISK = N'\\Chelsqlaagad001\p$\BAK\LodgingInventoryMaster09.bak' WITH  FILE = 1,  
MOVE N'LodgingInventory_sys' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_sys.ndf',  
MOVE N'LodgingInventory_data' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_data.mdf',  
MOVE N'LodgingInventory_Data2' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data2.ndf',  
MOVE N'LodgingInventory_Data3' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data3.ndf',  
MOVE N'LodgingInventory_Data4' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Data4.ndf',  
MOVE N'LodgingInventory_CDC' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_CDC.ndf',  
MOVE N'LodgingInventory_Log' TO N'D:\Data1\LodgingInventoryMaster09_LodgingInventory_Log.ldf',  
NOUNLOAD,  STATS = 5,NORECOVERY
GO


