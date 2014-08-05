Shindo.tests("Fog::Network[:openstack] | lb_pool", ['openstack']) do

  tests('success') do
    before do
      @lb_health_monitor =  Fog::Network[:openstack].lb_health_monitors.create(:type => 'PING',
                                                                               :delay => 1,
                                                                               :timeout => 5,
                                                                               :max_retries => 10)
    end

    after do
      @lb_health_monitor.destroy
    end

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].lb_pools.create(:subnet_id => 'subnet_id',
                                                           :protocol => 'HTTP',
                                                           :lb_method => 'ROUND_ROBIN',
                                                           :name => 'test-pool',
                                                           :description => 'Test Pool',
                                                           :admin_state_up => true,
                                                           :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.name = 'new-test-pool'
      @instance.description = 'New Test Pool'
      @instance.lb_method = 'LEAST_CONNECTIONS'
      @instance.admin_state_up = false
      @instance.update
    end

    tests('#stats').succeeds do
      @instance.stats
      !@instance.active_connections.nil?
    end

    tests('#associate_health_monitor').succeeds do
      @instance.associate_health_monitor(@lb_health_monitor.id)
    end

    tests('#disassociate_health_monitor').succeeds do
      @instance.disassociate_health_monitor(@lb_health_monitor.id)
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
