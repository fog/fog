Shindo.tests('HP::Network | networking floating ip requests', ['hp', 'networking', 'floatingip']) do

  @floating_ip_format = {
    'id'                  => String,
    'tenant_id'           => String,
    'floating_network_id' => String,
    'router_id'           => Fog::Nullable::String,
    'fixed_ip_address'    => Fog::Nullable::String,
    'floating_ip_address' => String,
    'port_id'             => Fog::Nullable::String
  }

  @ext_network_id = HP[:network].list_networks({'router:external'=>true}).body['networks'][0]['id']
  s_data = HP[:network].create_port(@ext_network_id, {:name => 'fog_port'}).body['port']
  @port_id = s_data['id']

  tests('success') do

    @floating_ip_id = nil

    tests("#create_floating_ip(#{@ext_network_id})").formats(@floating_ip_format) do
      data = HP[:network].create_floating_ip(@ext_network_id).body['floatingip']
      @floating_ip_id = data['id']
      data
    end

    tests('#list_floating_ips').formats({'floatingips' => [@floating_ip_format]}) do
      HP[:network].list_floating_ips.body
    end

    tests("#get_floating_ip(#{@floating_ip_id})").formats({'floatingip' => @floating_ip_format}) do
      HP[:network].get_floating_ip(@floating_ip_id).body
    end

    tests("#associate_floating_ip(#{@floating_ip_id}, #{@port_id})").formats({'floatingip' => @floating_ip_format}) do
      HP[:network].associate_floating_ip(@floating_ip_id, @port_id).body
    end

    tests("#disassociate_floating_ip(#{@floating_ip_id}, nil)").formats({'floatingip' => @floating_ip_format}) do
      HP[:network].disassociate_floating_ip(@floating_ip_id, nil).body
    end

    tests("#delete_floating_ip(#{@floating_ip_id})").succeeds do
      HP[:network].delete_floating_ip(@floating_ip_id)
    end

  end

  tests('failure') do
    tests('#get_floating_ip("0")').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_floating_ip(0)
    end

    tests("#associate_floating_ip('0', #{@port_id})").raises(Fog::HP::Network::NotFound) do
      HP[:network].associate_floating_ip('0', @port_id)
    end

    tests('#disassociate_floating_ip("0")').raises(Fog::HP::Network::NotFound) do
      HP[:network].disassociate_floating_ip("0")
    end

    tests('#delete_floating_ip("0")').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_floating_ip("0")
    end
  end

  # cleanup
  HP[:network].delete_port(@port_id)

end
