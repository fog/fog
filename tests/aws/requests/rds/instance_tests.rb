Shindo.tests('AWS::RDS | instance requests', ['aws', 'rds']) do
  # random_differentiator
  # Useful when rapidly re-running tests, so we don't have to wait
  # serveral minutes for deleted servers to disappear
  suffix = rand(65536).to_s(16)

  @db_instance_id       = "fog-test-#{suffix}"
  @db_replica_id        = "fog-replica-#{suffix}"
  @db_snapshot_id       = "fog-snapshot"
  @db_final_snapshot_id = "fog-final-snapshot"

  tests('success') do
    pending if Fog.mocking?

    tests("#create_db_instance").formats(AWS::RDS::Formats::CREATE_DB_INSTANCE) do
      result = Fog::AWS[:rds].create_db_instance(@db_instance_id, 'AllocatedStorage' => 5,
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
      Fog::AWS[:rds].describe_db_instances.body
    end

    server = Fog::AWS[:rds].servers.get(@db_instance_id)
    server.wait_for {ready?}

    new_storage = 6
    tests("#modify_db_instance with immediate apply").formats(AWS::RDS::Formats::MODIFY_DB_INSTANCE) do
      body = Fog::AWS[:rds].modify_db_instance(@db_instance_id, true, 'AllocatedStorage'=> new_storage).body
      tests 'pending storage' do
        instance = body['ModifyDBInstanceResult']['DBInstance']
        returns(new_storage){instance['PendingModifiedValues']['AllocatedStorage']}
      end
      body
    end

    server.reload.wait_for { state == 'modifying' }
    server.reload.wait_for { state == 'available' }

    tests 'new storage' do
      returns(new_storage){ server.allocated_storage}
    end

    tests("reboot db instance") do
      tests("#reboot").formats(AWS::RDS::Formats::REBOOT_DB_INSTANCE) do
        Fog::AWS[:rds].reboot_db_instance(@db_instance_id).body
      end
    end

    server.reload.wait_for { state == 'rebooting' }
    server.reload.wait_for { state == 'available'}

    tests("#create_db_snapshot").formats(AWS::RDS::Formats::CREATE_DB_SNAPSHOT) do
      body = Fog::AWS[:rds].create_db_snapshot(@db_instance_id, @db_snapshot_id).body
      returns('creating'){ body['CreateDBSnapshotResult']['DBSnapshot']['Status']}
      body
    end

    tests("#describe_db_snapshots").formats(AWS::RDS::Formats::DESCRIBE_DB_SNAPSHOTS) do
      body = Fog::AWS[:rds].describe_db_snapshots.body
    end

    server.reload.wait_for { state == 'available' }

    tests( "#create read replica").formats(AWS::RDS::Formats::CREATE_READ_REPLICA) do
      Fog::AWS[:rds].create_db_instance_read_replica(@db_replica_id, @db_instance_id).body
    end

    replica = Fog::AWS[:rds].servers.get(@db_replica_id)
    replica.wait_for {ready?}

    tests("replica source") do
      returns(@db_instance_id){replica.read_replica_source}
    end
    server.reload

    tests("replica identifiers") do
      returns([@db_replica_id]){server.read_replica_identifiers}
    end

    tests("#delete_db_instance").formats(AWS::RDS::Formats::DELETE_DB_INSTANCE) do
      #server.wait_for { state == 'available'}
      Fog::AWS[:rds].delete_db_instance(@db_replica_id, nil, true)
      body = Fog::AWS[:rds].delete_db_instance(@db_instance_id, @db_final_snapshot_id).body

      tests "final snapshot" do
        returns('creating'){Fog::AWS[:rds].describe_db_snapshots(:snapshot_id => @db_final_snapshot_id).body['DescribeDBSnapshotsResult']['DBSnapshots'].first['Status']}
      end
      body
    end

    tests("#delete_db_snapshot").formats(AWS::RDS::Formats::DELETE_DB_SNAPSHOT) do
      Fog::AWS[:rds].snapshots.get(@db_snapshot_id).wait_for { ready? }
      Fog::AWS[:rds].delete_db_snapshot(@db_snapshot_id).body
    end

    tests("snapshot.destroy") do
      snapshot = Fog::AWS[:rds].snapshots.get(@db_final_snapshot_id)
      snapshot.wait_for { ready? }
      snapshot.destroy
      returns(nil) { Fog::AWS[:rds].snapshots.get(@db_final_snapshot_id) }
    end

  end

  tests('failure') do
    pending if Fog.mocking?

    tests "deleting nonexisting instance" do
      raises(Fog::AWS::RDS::NotFound) {Fog::AWS[:rds].delete_db_instance('doesnexist', 'irrelevant')}
    end
    tests "deleting non existing snapshot" do
      raises(Fog::AWS::RDS::NotFound) {Fog::AWS[:rds].delete_db_snapshot('doesntexist')}
    end
    tests "modifying non existing instance" do
      raises(Fog::AWS::RDS::NotFound) { Fog::AWS[:rds].modify_db_instance 'doesntexit', true, 'AllocatedStorage'=> 10}
    end
  end
end
