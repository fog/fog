Shindo.tests('Fog::Network[:openstack] | port requests', ['openstack']) do

  @port_format = {
    'id'                    => String,
    'name'                  => String,
    'network_id'            => String,
    'fixed_ips'             => Array,
    'mac_address'           => String,
    'status'                => String,
    'admin_state_up'        => Fog::Boolean,
    'device_owner'          => String,
    'device_id'             => String,
    'tenant_id'             => String,
    'security_groups'       => Array,
    'allowed_address_pairs' => Array
  }

  tests('success') do
    tests('#create_port').formats({'port' => @port_format}) do
      network_id = 'net_id'
      attributes = {:name => 'port_name', :fixed_ips => [],
                    :mac_address => 'fa:16:3e:62:91:7f', :admin_state_up => true,
                    :device_owner => 'device_owner', :device_id => 'device_id',
                    :tenant_id => 'tenant_id' ,:security_groups => [],
                    :allowed_address_pairs => [] }
      Fog::Network[:openstack].create_port(network_id, attributes).body
    end

    tests('#list_port').formats({'ports' => [@port_format]}) do
      Fog::Network[:openstack].list_ports.body
    end

    tests('#get_port').formats({'port' => @port_format}) do
      port_id = Fog::Network[:openstack].ports.all.first.id
      Fog::Network[:openstack].get_port(port_id).body
    end

    tests('#update_port').formats({'port' => @port_format}) do
      port_id = Fog::Network[:openstack].ports.all.first.id
      attributes = {:name => 'port_name', :fixed_ips => [],
                    :admin_state_up => true, :device_owner => 'device_owner',
                    :device_id => 'device_id'}
      Fog::Network[:openstack].update_port(port_id, attributes).body
    end

    tests('#delete_port').succeeds do
      port_id = Fog::Network[:openstack].ports.all.first.id
      Fog::Network[:openstack].delete_port(port_id)
    end
  end

  tests('failure') do
    tests('#get_port').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_port(0)
    end

    tests('#update_port').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_port(0, {})
    end

    tests('#delete_port').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_port(0)
    end
  end

end
