-------------------------------------------------------------------------------------------------------
/* Execute this against the Principal Instance */
-------------------------------------------------------------------------------------------------------
-- Step 1 : 
--                    CREATE MASTER KEY,CREATE CERTIFICATE
--                   CREATE ENDPOINT,BACKUP CERTIFICATE to file
---------------------------------------------------------------------------------
USE MASTER
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'somepassword'
GO
 --Create the server-based certificate which will be used to encrypt the database mirroring endpoint 
CREATE CERTIFICATE PrincipalServerCertificate
WITH SUBJECT = 'PrincipalServer certificate',
START_DATE = '20170131',
EXPIRY_DATE = '20171130'
GO
 --Create the database mirroring endpoint for the principal server using the certificate for authentication 
CREATE ENDPOINT MirroringEndPoint
STATE = STARTED AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
FOR DATABASE_MIRRORING(AUTHENTICATION = CERTIFICATE PrincipalServerCertificate
,ENCRYPTION = REQUIRED ALGORITHM RC4,ROLE = ALL)
GO
BACKUP CERTIFICATE PrincipalServerCertificate
TO FILE = 'c:\PrincipalServerCertificate.cer'
GO

 --------------------------------------------------------------------------------------------------------------------------
/* Execute this against the Mirror Instance */
---------------------------------------------------------------------------------------------------------------------------
-- Step 2 : 
--              CREATE MASTER KEY,CREATE CERTIFICATE,
--              CREATE ENDPOINT,BACKUP CERTIFICATE to file
----------------------------------------------------------------------------------
USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'somepassword'
GO
--Create the server-based certificate which will be used to encrypt the database mirroring endpoint 
CREATE CERTIFICATE MirrorServerCertificate 
WITH SUBJECT = 'MirrorServer certificate',
START_DATE = '20170131',
EXPIRY_DATE = '20171130'
GO 
CREATE ENDPOINT MirroringEndPoint 
STATE = STARTED AS TCP (LISTENER_PORT = 5023, LISTENER_IP = ALL)
FOR DATABASE_MIRRORING (AUTHENTICATION = CERTIFICATE MirrorServerCertificate,
ENCRYPTION = REQUIRED ALGORITHM RC4,ROLE = ALL)
GO
BACKUP CERTIFICATE MirrorServerCertificate TO FILE = 'c:\MirrorServerCertificate.cer';
GO

------------------------------------------------------------------------------------------------------------------------
/* Execute this against the Principal Instance.     
     The MirrorServerCertificate.cer needs to be copied on the Principal Server.
*/
-------------------------------------------------------------------------------------------------------------------------
-- Step 3 : 
--               CREATE LOGIN,CREATE USER,CREATE CERTIFICATE (from Mirror server) 
--               and grant the created User to it.
------------------------------------------------------------------------------------------------------------------------
USE MASTER
GO
CREATE LOGIN MirrorLogin WITH PASSWORD = 'somepassword'
GO
CREATE USER MirrorUser FOR LOGIN MirrorLogin
GO
CREATE CERTIFICATE MirrorServerCertificate AUTHORIZATION MirrorUser 
FROM FILE ='c:\MirrorServerCertificate.cer'
GO
GRANT CONNECT ON ENDPOINT::MirroringEndPoint TO [MirrorLogin]
GO


/* Execute this against the Mirror Instance.  
    The PrincipalServerCertificate.cer needs to be copied on the Mirror Server.
*/
----------------------------------------------------------------------------------------------------------------------
-- Step 4 : 
--                CREATE LOGIN,CREATE USER,CREATE CERTIFICATE (from Principal server) 
--                and grant the created User to it.
----------------------------------------------------------------------------------------------------------------------
USE MASTER
GO
CREATE LOGIN PrincipalLogin WITH PASSWORD = 'somepassword'
GO
CREATE USER PrincipalUser FOR LOGIN PrincipalLogin
GO
CREATE CERTIFICATE PrincipalServerCertificate AUTHORIZATION PrincipalUser 
FROM FILE = 'c:\PrincipalServerCertificate.cer'
GO
GRANT CONNECT ON ENDPOINT::MirroringEndPoint TO [PrincipalLogin]
GO

/* Execute this against the Mirror Instance.*/
------------------------------------------------------------------------------------------------
-- Step 5 : 
--             Prepare the mirror server for the database mirroring session 
------------------------------------------------------------------------------------------------
ALTER DATABASE TESTDB 
SET PARTNER = 'TCP://PrincipalServerIP:5022'
GO

/* Execute this against the Principal Instance.*/
-------------------------------------------------------------------------------------------------
-- Step 6 : 
--            Prepare the Principal server for the database mirroring session 
-------------------------------------------------------------------------------------------------
ALTER DATABASE TestDB
SET PARTNER = 'TCP://MirrorServerIP:5023'
GO
-- Set the Mirroring to Asynchronous mode (if needed)
ALTER DATABASE TestDB SET PARTNER SAFETY OFF
GO
