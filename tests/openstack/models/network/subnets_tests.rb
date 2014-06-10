Shindo.tests("Fog::Network[:openstack] | subnets", ['openstack']) do
  @subnet = Fog::Network[:openstack].subnets.create(:name => 'subnet_name',
                                                    :network_id => 'net_id',
                                                    :cidr => '10.2.2.0/24',
                                                    :ip_version => 4,
                                                    :gateway_ip => '10.2.2.1',
                                                    :allocation_pools => [],
                                                    :dns_nameservers => [],
                                                    :host_routes => [],
                                                    :enable_dhcp => true,
                                                    :tenant_id => 'tenant_id')
  @subnets = Fog::Network[:openstack].subnets

  tests('success') do

    tests('#all').succeeds do
      @subnets.all
    end

    tests('#get').succeeds do
      @subnets.get @subnet.id
    end

  end

  @subnet.destroy
end
