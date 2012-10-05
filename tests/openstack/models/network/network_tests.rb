Shindo.tests("Fog::Network[:openstack] | network", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].networks.create(:name => 'net_name',
                                                           :shared => false,
                                                           :admin_state_up => true,
                                                           :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.name = 'new_net_name'
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
