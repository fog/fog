Shindo.tests("Fog::Network[:openstack] | port", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].ports.create(:name => 'port_name',
                                                        :network_id => 'net_id',
                                                        :fixed_ips => [],
                                                        :mac_address => 'fa:16:3e:62:91:7f',
                                                        :admin_state_up => true,
                                                        :device_owner => 'device_owner',
                                                        :device_id => 'device_id',
                                                        :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.name = 'new_port_name'
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
