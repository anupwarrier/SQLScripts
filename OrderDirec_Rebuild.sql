--CHELSQDBDEV004\OMS001
USE [master]
RESTORE DATABASE [OrderDirectory] 
FROM  DISK = N'D:\Data1\ORderDirectory_a.bak',  
DISK = N'D:\Data2\ORderDirectory_b.bak',  
DISK = N'D:\Data3\ORderDirectory_c.bak' 
WITH  FILE = 1,  MOVE N'OrderDirectory' TO N'E:\Data1\OrderDirectory.mdf',  
MOVE N'OrderDirectory_1' TO N'E:\Data2\OrderDirectory_1.ndf',  
MOVE N'OrderDirectory_log' TO N'E:\Log1\OrderDirectory_log.ldf',  
NOUNLOAD,  STATS = 5
GO

--CHELSQDBDEV005\OMS002

USE [master]
RESTORE DATABASE [OrderDirectory] FROM  DISK = N'D:\Data2\ORderDirectory_a.bak',  
DISK = N'D:\Data2\ORderDirectory_b.bak',  DISK = N'D:\Data2\ORderDirectory_c.bak' WITH  FILE = 1,  
MOVE N'OrderDirectory' TO N'E:\Data1\OrderDirectory.mdf',  
MOVE N'OrderDirectory_1' TO N'E:\Data2\OrderDirectory_1.ndf',  
MOVE N'OrderDirectory_log' TO N'E:\Log1\OrderDirectory_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
GO

--PHELSQDBDEV004

USE [master]
RESTORE DATABASE [OrderDirectory] FROM  DISK = N'E:\ORderDirectory_a.bak',  
DISK = N'E:\ORderDirectory_b.bak',  DISK = N'E:\ORderDirectory_c.bak' WITH  FILE = 1,  
MOVE N'OrderDirectory' TO N'D:\Data01\OrderDirectory.mdf',  
MOVE N'OrderDirectory_1' TO N'D:\Data02\OrderDirectory_1.ndf',  
MOVE N'OrderDirectory_log' TO N'D:\Log01\MSSQLSERVR\OrderDirectory_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
GO


--PHELSQDBDEV005
USE [master]
RESTORE DATABASE [OrderDirectory] FROM  DISK = N'E:\ORderDirectory_a.bak',  
DISK = N'E:\ORderDirectory_b.bak',  DISK = N'E:\ORderDirectory_c.bak' WITH  FILE = 1, 
MOVE N'OrderDirectory' TO N'D:\Data01\OrderDirectory.mdf',  
MOVE N'OrderDirectory_1' TO N'D:\Data02\OrderDirectory_1.ndf',  
MOVE N'OrderDirectory_log' TO N'D:\Log01\MSSQLSERVR\OrderDirectory_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5

GO


