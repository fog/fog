Shindo.tests('HP::Network | networking subnet requests', ['hp', 'networking', 'subnet']) do

  @subnet_format = {
    'id'               => String,
    'name'             => Fog::Nullable::String,
    'network_id'       => String,
    'cidr'             => String,
    'ip_version'       => Integer,
    'gateway_ip'       => Fog::Nullable::String,
    'allocation_pools' => Fog::Nullable::Array,
    'dns_nameservers'  => Fog::Nullable::Array,
    'host_routes'      => Fog::Nullable::Array,
    'enable_dhcp'      => Fog::Boolean,
    'tenant_id'        => String,
  }

  n_data = HP[:network].create_network({:name => 'fog_network'}).body['network']
  @network_id = n_data['id']

  tests('success') do

    @subnet_id = nil

    tests('#create_subnet').formats(@subnet_format) do
      attributes = {:name => 'mysubnet', :gateway_ip => '10.0.3.1',
                    :allocation_pools => [], :dns_nameservers => [],
                    :host_routes => [], :enable_dhcp => true, :tenant_id => '111111111'}
      data = HP[:network].create_subnet(@network_id, '10.0.3.0/24', 4, attributes).body['subnet']
      @subnet_id = data['id']
      data
    end

    tests('#list_subnets').formats({'subnets' => [@subnet_format]}) do
      HP[:network].list_subnets.body
    end

    tests("#get_subnet(#{@subnet_id})").formats({'subnet' => @subnet_format}) do
      HP[:network].get_subnet(@subnet_id).body
    end

    tests("#update_subnet(#{@subnet_id})").formats({'subnet' => @subnet_format}) do
      attributes = {:name => 'mysubnet_upd',:gateway_ip => '10.0.3.1',
                          :dns_nameservers => [], :host_routes => [],
                          :enable_dhcp => true}
      HP[:network].update_subnet(@subnet_id, attributes).body
    end

    tests("#delete_subnet(#{@subnet_id})").succeeds do
      HP[:network].delete_subnet(@subnet_id)
    end

  end

  tests('failure') do
    tests('#get_subnet(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_subnet(0)
    end

    tests('#update_subnet(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].update_subnet(0, {})
    end

    tests('#delete_subnet(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_subnet(0)
    end
  end

  # cleanup
  HP[:network].delete_network(@network_id)

end
