Shindo.tests('Fog::Network[:openstack] | network requests', ['openstack']) do

  @network_format = {
    'id'             => String,
    'name'           => String,
    'subnets'        => Array,
    'shared'         => Fog::Boolean,
    'status'         => String,
    'admin_state_up' => Fog::Boolean,
    'tenant_id'      => String,
  }

  tests('success') do
    tests('#create_network').formats({'network' => @network_format}) do
      attributes = {:name => 'net_name', :shared => false,
                    :admin_state_up => true, :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_network(attributes).body
    end

    tests('#list_networks').formats({'networks' => [@network_format]}) do
      Fog::Network[:openstack].list_networks.body
    end

    tests('#get_network').formats({'network' => @network_format}) do
      network_id = Fog::Network[:openstack].networks.all.first.id
      Fog::Network[:openstack].get_network(network_id).body
    end

    tests('#update_network').formats({'network' => @network_format}) do
      network_id = Fog::Network[:openstack].networks.all.first.id
      attributes = {:name => 'net_name', :shared => false,
                    :admin_state_up => true}
      Fog::Network[:openstack].update_network(network_id, attributes).body
    end

    tests('#delete_network').succeeds do
      network_id = Fog::Network[:openstack].networks.all.first.id
      Fog::Network[:openstack].delete_network(network_id)
    end
  end

  tests('failure') do
    tests('#get_network').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_network(0)
    end

    tests('#update_network').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_network(0, {})
    end

    tests('#delete_network').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_network(0)
    end
  end

end