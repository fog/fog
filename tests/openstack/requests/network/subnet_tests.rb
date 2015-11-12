Shindo.tests('Fog::Network[:openstack] | subnet requests', ['openstack']) do

  @subnet_format = {
    'id'               => String,
    'name'             => String,
    'network_id'       => String,
    'cidr'             => String,
    'ip_version'       => Integer,
    'gateway_ip'       => String,
    'allocation_pools' => Array,
    'dns_nameservers'  => Array,
    'host_routes'      => Array,
    'enable_dhcp'      => Fog::Boolean,
    'tenant_id'        => String,
  }

  tests('success') do
    tests('#create_subnet').formats({'subnet' => @subnet_format}) do
      network_id = 'net_id'
      cidr = '10.2.2.0/24'
      ip_version = 4
      attributes = {:name => 'subnet_name', :gateway_ip => '10.2.2.1',
                    :allocation_pools => [], :dns_nameservers => [],
                    :host_routes => [], :enable_dhcp => true,
                    :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_subnet(network_id, cidr, ip_version, attributes).body
    end

    tests('#list_subnet').formats({'subnets' => [@subnet_format]}) do
      Fog::Network[:openstack].list_subnets.body
    end

    tests('#get_subnet').formats({'subnet' => @subnet_format}) do
      subnet_id = Fog::Network[:openstack].subnets.all.first.id
      Fog::Network[:openstack].get_subnet(subnet_id).body
    end

    tests('#update_subnet').formats({'subnet' => @subnet_format}) do
      subnet_id = Fog::Network[:openstack].subnets.all.first.id
      attributes = {:name => 'subnet_name', :gateway_ip => '10.2.2.1',
                    :allocation_pools => [], :dns_nameservers => [],
                    :host_routes => [], :enable_dhcp => true}
      Fog::Network[:openstack].update_subnet(subnet_id, attributes).body
    end

    tests('#delete_subnet').succeeds do
      subnet_id = Fog::Network[:openstack].subnets.all.first.id
      Fog::Network[:openstack].delete_subnet(subnet_id)
    end
  end

  tests('failure') do
    tests('#get_subnet').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_subnet(0)
    end

    tests('#update_subnet').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_subnet(0, {})
    end

    tests('#delete_subnet').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_subnet(0)
    end
  end

end
