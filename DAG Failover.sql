ALTER AVAILABILITY GROUP [distributedag] 
MODIFY 
AVAILABILITY GROUP ON
'EXELSQAAG' WITH  
   ( 
    LISTENER_URL = 'tcp://EXELSQAADDBA001:5022',  
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
    FAILOVER_MODE = MANUAL, 
    SEEDING_MODE = MANUAL 
    ), 
'LIMAWSAG' WITH  
  ( 
  LISTENER_URL = 'tcp://LIMAWSLIS1:5022', 
  AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
  FAILOVER_MODE = MANUAL, 
  SEEDING_MODE = MANUAL 
  );  



  SELECT ag.name
       , drs.database_id
       , drs.group_id
       , drs.replica_id
       , drs.synchronization_state_desc
       , drs.end_of_log_lsn,
	   ar.replica_server_name
  FROM sys.dm_hadr_database_replica_states drs
  JOIN sys.availability_replicas ar
  ON ar.replica_id = drs.replica_id
  JOIN 
  sys.availability_groups ag ON
  drs.group_id = ag.group_id; 



	





















  ---- Distributed AAG Setup 
--CH Side
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
'LIMAWSAG' WITH    
(   
LISTENER_URL = 'tcp://LIMAWSLIS1:5022',   
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
);    
GO  
--AWS Side
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
'LIMAWSAG' WITH    
(   
LISTENER_URL = 'tcp://LIMAWSLIS1:5022',   
AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,   
FAILOVER_MODE = MANUAL,   
SEEDING_MODE = MANUAL   
);    
GO  

4. Restore DB on AWS side with recovering state. 
5. Run the command 
ALTER DATABASE [LodgingInventoryMaster09] SET HADR AVAILABILITY GROUP = LIMAWSAG
