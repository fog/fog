Shindo.tests("Fog::Network[:openstack] | ports", ['openstack']) do
  @port = Fog::Network[:openstack].ports.create(:name => 'port_name',
                                                :network_id => 'net_id',
                                                :fixed_ips => [],
                                                :mac_address => 'fa:16:3e:62:91:7f',
                                                :admin_state_up => true,
                                                :device_owner => 'device_owner',
                                                :device_id => 'device_id',
                                                :tenant_id => 'tenant_id')
  @ports = Fog::Network[:openstack].ports

  tests('success') do

    tests('#all').succeeds do
      @ports.all
    end

    tests('#get').succeeds do
      @ports.get @port.id
    end

  end

  @port.destroy
end
