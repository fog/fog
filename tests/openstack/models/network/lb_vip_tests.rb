Shindo.tests("Fog::Network[:openstack] | lb_vip", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].lb_vips.create(:subnet_id => 'subnet_id',
                                                          :pool_id => 'pool_id',
                                                          :protocol => 'HTTP',
                                                          :protocol_port => 80,
                                                          :name => 'test-vip',
                                                          :description => 'Test VIP',
                                                          :address => '10.0.0.1',
                                                          :session_persistence => {
                                                            "cookie_name" => "COOKIE_NAME",
                                                            "type" => "APP_COOKIE"
                                                          },
                                                          :connection_limit => 10,
                                                          :admin_state_up => true,
                                                          :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.pool_id = 'new_pool_id',
      @instance.name = 'new-test-vip'
      @instance.description = 'New Test VIP'
      @instance.session_persistence = { "type" => "HTTP_COOKIE" }
      @instance.connection_limit = 5
      @instance.admin_state_up = false
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
