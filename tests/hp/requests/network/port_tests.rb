Shindo.tests('HP::Network | networking port requests', ['hp', 'networking', 'port']) do

  @port_format = {
    'id'                => String,
    'name'              => Fog::Nullable::String,
    'network_id'        => String,
    'fixed_ips'         => Array,
    'mac_address'       => String,
    'status'            => String,
    'admin_state_up'    => Fog::Boolean,
    'binding:vif_type'  => String,
    'device_owner'      => String,
    'device_id'         => String,
    'security_groups'   => Array,
    'tenant_id'         => String
  }

  n_data = HP[:network].create_network({:name => 'fog_network'}).body['network']
  @network_id = n_data['id']

  tests('success') do

    @port_id = nil

    tests('#create_port').formats(@port_format) do
      attributes = {:name => 'myport', :fixed_ips => [],
                    :mac_address => 'fa:16:3e:71:26:c8', :admin_state_up => true,
                    :device_owner => '2222222', :device_id => '3333333', :tenant_id => '111111111'}
      data = HP[:network].create_port(@network_id, attributes).body['port']
      @port_id = data['id']
      data
    end

    tests('#list_port').formats({'ports' => [@port_format]}) do
      HP[:network].list_ports.body
    end

    tests("#get_port(#{@port_id})").formats({'port' => @port_format}) do
      HP[:network].get_port(@port_id).body
    end

    tests("#update_port(#{@port_id})").formats({'port' => @port_format}) do
      attributes = {:name => 'myport_upd', :fixed_ips => [],
                    :admin_state_up => true, :device_owner => 'device_owner',
                    :device_id => 'device_id'}
      HP[:network].update_port(@port_id, attributes).body
    end

    tests("#delete_port(#{@port_id})").succeeds do
      HP[:network].delete_port(@port_id)
    end
  end

  tests('failure') do
    tests('#get_port(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_port(0)
    end

    tests('#update_port(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].update_port(0, {})
    end

    tests('#delete_port(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_port(0)
    end
  end

  # cleanup
  HP[:network].delete_network(@network_id)

end
