select
		 'REDO_QUEUE'  
		,ar.replica_server_name AS ag_replica_server
		,db_name(dr_state.database_id) as 'DBName'
	
		,is_ag_replica_local 
			= case
				when ar_state.is_local = 1 then N'LOCAL'
				else 'REMOTE'
				end
		,ag_replica_role
			= case
				when ar_state.role_desc is null then N'DISCONNECTED'
				else ar_state.role_desc  
				end
		,isnull(max(dr_state.redo_queue_size),0) as 'MaxRedoQueueSize'
  
	from
		(( sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id ) 
	join
		sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id) 
	join
		sys.dm_hadr_database_replica_states dr_state on ag.group_id		= dr_state.group_id 
										and dr_state.replica_id			= ar_state.replica_id
	group by
		 ar.replica_server_name
		,db_name(dr_state.database_id) 
		,   case
				when ar_state.is_local = 1 then N'LOCAL'
				else 'REMOTE'
				end
		,   case
				when ar_state.role_desc is null then N'DISCONNECTED'
				else ar_state.role_desc  
				end