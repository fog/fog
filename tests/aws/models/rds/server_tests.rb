Shindo.tests("AWS::RDS | server", ['aws', 'rds']) do

  @params = {:id => uniq_id, :allocated_storage => 5, :engine => 'mysql',
    :master_username => 'foguser', :password => 'fogpassword',
    :backup_retention_period => 0
  }

  model_tests(AWS[:rds].servers, @params, false) do
    # We'll need this later; create it early to avoid waiting
    @instance_with_final_snapshot = AWS[:rds].servers.create(@params.merge(:id => uniq_id("fog-snapshot-test")))

    @instance.wait_for { ready? }

    tests('#snapshots') do
      snapshot = nil

      tests('#create').succeeds do
        snapshot = @instance.snapshots.create(:id => 'fog-test-snapshot')
      end

      snapshot.wait_for {ready?}

      @instance.reload
      @instance.wait_for { ready? }

      returns(true) { @instance.snapshots.map{|s| s.id}.include?(snapshot.id) }
      snapshot.destroy
    end

    tests("#modify").succeeds do
      orig_parameter_group = @instance.db_parameter_groups.first['DBParameterGroupName'] 
      parameter_group = AWS[:rds].parameter_groups.create(:id => uniq_id, :family => 'mysql5.1', :description => 'fog-test')

      orig_security_groups = @instance.db_security_groups.map{|h| h['DBSecurityGroupName']}
      security_group = AWS[:rds].security_group.create(:id => uniq_id, :description => 'fog-test')

      modify_options = {
        'DBParameterGroupName' => parameter_group.id,
        'DBSecurityGroups' => orig_security_groups << security_group.id
      }

      @instance.modify(true, modify_options)
      @instance.reload

      returns(parameter_group.id, 'new parameter group') do
        @instance.db_parameter_groups.first['DBParameterGroupName']
      end

      returns(true, "new security group") do
        @instance.db_security_groups.any?{|hash| hash['DBSecurityGroupName'] == security_group.id}
      end

      @instance.wait_for { ready? }

      # Restore back to original state
      restore_options = {
       'DBParameterGroupName' => orig_parameter_group,
       'DBSecurityGroups' => orig_security_groups
      }
      @instance.modify(true, restore_options)

      parameter_group.destroy
      security_group.destroy
    end

    tests("#reboot").succeeds do
      @instance.reboot
    end
    @instance.wait_for {state == 'rebooting'}
    @instance.wait_for { ready? }

    test("Destroying with a final snapshot") do
      final_snapshot_id = 'fog-test-snapshot'

      @instance_with_final_snapshot.wait_for { ready? }
      @instance_with_final_snapshot.destroy(final_snapshot_id)
      returns(true, "Final snapshot created") do
        @final_snapshot = AWS[:rds].snapshots.get(final_snapshot_id)
        !@final_snapshot.nil?
      end

      @final_snapshot.wait_for { ready? }
      @final_snapshot.destroy
    end

  end
end
