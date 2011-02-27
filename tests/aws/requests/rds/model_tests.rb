Shindo.tests('AWS::RDS | models', ['aws', 'rds']) do
  @db_instance_id='fog-test'
  @db_replica_id='fog-replica'

  tests('success') do
    pending if Fog.mocking?
    
    tests('parametergroups') do
      group = nil

      tests('create') do
        group = AWS[:rds].parameter_groups.create :id => 'testgroup', :family => 'mysql5.1', :description => 'test'
      end

      tests('#parameters') do
        parameters = group.parameters
        #search for a sample parameter
        tests 'contains parameter' do
          returns(true){ !!parameters.detect {|p| p.name == 'query_cache_size'}}
        end
      end
      
      tests('modify') do
        group.modify([{:name => 'query_cache_size', :value => '6553600', :apply_method => 'immediate'}])

        tests 'parameter has changed' do
          returns('6553600'){group.parameters.detect {|p| p.name == 'query_cache_size'}.value}
        end
      end
      
      tests('destroy').succeeds do
        group.destroy
      end

      returns(nil){AWS[:rds].parameter_groups.detect {|g| g.id == 'testgroup'}}      
    end
    
    tests('servers') do
      server = nil
      tests('create').succeeds do
        server = AWS[:rds].servers.create( :id => @db_instance_id, :allocated_storage => 5, :engine => 'mysql',
                                                        :master_username => 'foguser', :password => 'fogpassword',
                                                        :backup_retention_period => 0)
      end
    
      server.wait_for {ready?}
    
      tests('snapshots') do
        snapshot = nil
      
        tests('create').succeeds do
          snapshot = server.snapshots.create(:id => 'testsnapshot')
        end
      
        returns(@db_instance_id){snapshot.instance_id}
        server.reload
        server.wait_for {ready?}
        snapshot.wait_for {ready?}
        tests('all') do
          returns(['testsnapshot']){server.snapshots.collect {|s| s.id}}
        end
      
        tests('destroy').succeeds do
          snapshot.destroy
        end
      
        returns([]) {server.snapshots}
      end
    
      group = AWS[:rds].parameter_groups.create :id => 'some-group', :family => 'mysql5.1', :description => 'test'
      tests('modify') do
        server.modify(true, 'DBParameterGroupName' => 'some-group')
        server.reload
        returns('some-group'){server.db_parameter_groups.first['DBParameterGroupName']}
      end
      
      tests('reboot').succeeds do
        server.reboot
      end
      server.wait_for {state == 'rebooting'}
      server.wait_for {state == 'available'}
        
      tests('destroy').succeeds do
        server.destroy('finalsnapshot')      
      end
      
      Fog.wait_for do
        AWS[:rds].servers.length == 0
      end
      
      group.destroy

      tests("final snapshot was created") do
        AWS[:rds].snapshots.get('finalsnapshot').destroy
      end
    end
  end
end