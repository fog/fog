Shindo.tests("Fog::Network[:openstack] | lb_member", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].lb_members.create(:pool_id => 'pool_id',
                                                             :address => '10.0.0.1',
                                                             :protocol_port => '80',
                                                             :weight => 100,
                                                             :admin_state_up => true,
                                                             :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.pool_id = 'new_pool_id'
      @instance.weight = 50
      @instance.admin_state_up = false
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
