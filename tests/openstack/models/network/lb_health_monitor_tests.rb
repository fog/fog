Shindo.tests("Fog::Network[:openstack] | lb_health_monitor", ['openstack']) do

  tests('success') do
    before do
      @lb_pool = Fog::Network[:openstack].lb_pools.create(:subnet_id => 'subnet_id',
                                                          :protocol => 'HTTP',
                                                          :lb_method => 'ROUND_ROBIN')
    end

    after do
      @lb_pool.destroy
    end

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].lb_health_monitors.create(:type => 'PING',
                                                                     :delay => 1,
                                                                     :timeout => 5,
                                                                     :max_retries => 10,
                                                                     :http_method => 'GET',
                                                                     :url_path => '/',
                                                                     :expected_codes => '200, 201',
                                                                     :admin_state_up => true,
                                                                     :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.delay = 5
      @instance.timeout = 10
      @instance.max_retries = 20
      @instance.http_method = 'POST'
      @instance.url_path = '/varz'
      @instance.expected_codes = '200'
      @instance.admin_state_up = false
      @instance.update
    end

    tests('#associate_to_pool').succeeds do
      @instance.associate_to_pool(@lb_pool.id)
    end

    tests('#disassociate_from_pool').succeeds do
      @instance.disassociate_from_pool(@lb_pool.id)
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
