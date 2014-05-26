Shindo.tests("Fog::Network[:openstack] | subnet", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].subnets.create(:name => 'subnet_name',
                                                          :network_id => 'net_id',
                                                          :cidr => '10.2.2.0/24',
                                                          :ip_version => 4,
                                                          :gateway_ip => '10.2.2.1',
                                                          :allocation_pools => [],
                                                          :dns_nameservers => [],
                                                          :host_routes => [],
                                                          :enable_dhcp => true,
                                                          :tenant_id => 'tenant_id')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.name = 'new_subnet_name'
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
