Shindo.tests('AWS::RDS | instance requests', ['aws', 'rds']) do
  @db_instance_id='fog-test'
  @db_replica_id='fog-replica'
  
  tests('success') do
    pending if Fog.mocking?
    
    tests("#create_db_instance").formats(AWS::RDS::Formats::CREATE_DB_INSTANCE) do
      result = AWS[:rds].create_db_instance(@db_instance_id, 'AllocatedStorage' => 5,
                                                'DBInstanceClass' => 'db.m1.small',
                                                'Engine' => 'mysql',
                                                'EngineVersion' => '5.1.50',
                                                'MasterUsername' => 'foguser',
                                                'BackupRetentionPeriod' => 1,
                                                'MasterUserPassword' => 'fogpassword').body
    
      instance = result['CreateDBInstanceResult']['DBInstance']
      returns('creating'){ instance['DBInstanceStatus']}
      result
    end
       
    tests("#describe_db_instances").formats(AWS::RDS::Formats::DESCRIBE_DB_INSTANCES) do
      AWS[:rds].describe_db_instances.body
    end
    
    server = AWS[:rds].servers.get(@db_instance_id)
    server.wait_for {ready?}
    
    
    tests("#modify_db_instance with immediate apply").formats(AWS::RDS::Formats::MODIFY_DB_INSTANCE) do
      body = AWS[:rds].modify_db_instance( @db_instance_id, true, 'AllocatedStorage'=> 10).body
      tests 'pending storage' do
        instance = body['ModifyDBInstanceResult']['DBInstance']
        returns(10){instance['PendingModifiedValues']['AllocatedStorage']}
      end
      body      
    end
    server.wait_for { state == 'modifying'}
    server.wait_for { state == 'available'}
  
    server.reload
    tests 'new storage' do
      returns(10){ server.allocated_storage}
    end
    server.wait_for { state == 'available'}

    tests("reboot db instance") do
      tests("#reboot").formats(AWS::RDS::Formats::REBOOT_DB_INSTANCE) do
        AWS[:rds].reboot_db_instance( @db_instance_id).body
      end

      server.wait_for { state == 'rebooting'}
      server.wait_for { state == 'available'}
      server.reload
    end
    
    
    tests("#create_db_snapshot").formats(AWS::RDS::Formats::CREATE_DB_SNAPSHOT) do
      body = AWS[:rds].create_db_snapshot(@db_instance_id, 'fog-snapshot').body
      returns('creating'){ body['CreateDBSnapshotResult']['DBSnapshot']['Status']}
      body
    end
    
    tests("#describe_db_snapshots").formats(AWS::RDS::Formats::DESCRIBE_DB_SNAPSHOTS) do
      body = AWS[:rds].describe_db_snapshots().body
    end
    
    Fog.wait_for do
      data = AWS[:rds].describe_db_snapshots(:snapshot_id => 'fog-snapshot')
      status = data.body['DescribeDBSnapshotsResult']['DBSnapshots'].first['Status']
      status =='available'
    end
    
    tests( "#create read replica").formats(AWS::RDS::Formats::CREATE_READ_REPLICA) do
      AWS[:rds].create_db_instance_read_replica(@db_replica_id, @db_instance_id).body
    end
    
    replica = AWS[:rds].servers.get(@db_replica_id)
    replica.wait_for {ready?}
    
    tests("replica source") do
      returns(@db_instance_id){replica.read_replica_source}
    end
    server.reload
    
    tests("replica identifiers") do
      returns([@db_replica_id]){server.read_replica_identifiers}
    end

    tests("#delete_db_instance").formats(AWS::RDS::Formats::DELETE_DB_INSTANCE) do
      server.wait_for { state == 'available'}
      AWS[:rds].delete_db_instance(@db_replica_id, nil, true)
      body = AWS[:rds].delete_db_instance(@db_instance_id, 'fog-final-snapshot').body
      Fog.wait_for do
        AWS[:rds].servers.length == 0
      end
      
      tests "final snapshot" do
        returns('available'){AWS[:rds].describe_db_snapshots(:snapshot_id => 'fog-final-snapshot').body['DescribeDBSnapshotsResult']['DBSnapshots'].first['Status']}
      end
      body
    end
    
    
    
    tests("#delete_db_snapshot").formats(AWS::RDS::Formats::DELETE_DB_SNAPSHOT) do
      AWS[:rds].delete_db_snapshot('fog-snapshot').body
    end
    
    AWS[:rds].delete_db_snapshot('fog-final-snapshot')
    
    returns([]){ AWS[:rds].describe_db_snapshots.body['DescribeDBSnapshotsResult']['DBSnapshots']}
        
  end
  
  tests('failure') do
    pending if Fog.mocking?
    
    tests "deleting nonexisting instance" do
      raises(Fog::AWS::RDS::NotFound) {AWS[:rds].delete_db_instance('doesnexist', 'irrelevant')}      
    end
    tests "deleting non existing snapshot" do
      raises(Fog::AWS::RDS::NotFound) {AWS[:rds].delete_db_snapshot('doesntexist')}          
    end
    tests "modifying non existing instance" do
      raises(Fog::AWS::RDS::NotFound) { AWS[:rds].modify_db_instance 'doesntexit', true, 'AllocatedStorage'=> 10}
    end
  end
end
  
    