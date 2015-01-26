Shindo.tests('HP::Network | networking router requests', ['hp', 'networking', 'router']) do

  @router_format = {
    'id'                    => String,
    'name'                  => String,
    'tenant_id'             => String,
    'status'                => String,
    'admin_state_up'        => Fog::Boolean,
    'external_gateway_info' => Fog::Nullable::Hash
  }

  @router_interface_format = {
    'subnet_id'  => String,
    'port_id'    => String
  }

  n_data = HP[:network].create_network({:name => 'fog_network'}).body['network']
  @network_id = n_data['id']

  p_data = HP[:network].create_port(@network_id, {:name => 'fog_port'}).body['port']
  @port_id = p_data['id']

  tests('success') do

    @router_id = nil

    tests('#create_router').formats(@router_format) do
      attributes = {:name => 'my_router', :admin_state_up => true}
      data = HP[:network].create_router(attributes).body['router']
      @router_id = data['id']
      data
    end

    tests('#list_routers').formats({'routers' => [@router_format]}) do
      HP[:network].list_routers.body
    end

    tests("#get_router(#{@router_id})").formats({'router' => @router_format}) do
      HP[:network].get_router(@router_id).body
    end

    tests("#update_router(#{@router_id})").formats({'router' => @router_format}) do
      attributes = {
        :name => 'my_router_upd',
        :external_gateway_info => { :network_id => '11111111111' },
        :admin_state_up => true
      }
      HP[:network].update_router(@router_id, attributes).body
    end

    tests("#add_router_interface(#{@router_id}, '1111111111', nil) - using subnet_id").formats(@router_interface_format) do
      HP[:network].add_router_interface(@router_id, '1111111111', nil).body
    end

    #tests("#remove_router_interface(#{@router_id}, '1111111111', nil) - using subnet_id").formats('') do
    #  HP[:network].remove_router_interface(@router_id, '1111111111', nil).body
    #end

    tests("#add_router_interface(#{@router_id}, nil, #{@port_id}) - using port_id").formats(@router_interface_format) do
      HP[:network].add_router_interface(@router_id, nil, @port_id).body
    end

    tests("#add_router_interface(#{@router_id}, '1111111111', '2222222222') - using port_id and subnet_id").raises(ArgumentError) do
      HP[:network].add_router_interface(@router_id, '1111111111', '2222222222').body
    end

    tests("#remove_router_interface(#{@router_id}, nil, #{@port_id}) - using port_id").formats('') do
      HP[:network].remove_router_interface(@router_id, nil, @port_id).body
    end

    tests("#remove_router_interface(#{@router_id}, '1111111111', '2222222222') - using port_id and subnet_id").raises(ArgumentError) do
      HP[:network].remove_router_interface(@router_id, '1111111111', '2222222222').body
    end

    tests("#delete_router(#{@router_id})").succeeds do
      HP[:network].delete_router(@router_id)
    end
  end

  tests('failure') do
    tests('#get_router(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_router(0)
    end

    tests('#update_router(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].update_router(0, {})
    end

    tests('#delete_router(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_router(0)
    end

    tests("#add_router_interface(0, '1111111111')").raises(Fog::HP::Network::NotFound) do
      HP[:network].add_router_interface(0, '1111111111').body
    end

    tests("#remove_router_interface(0, '1111111111')").raises(Fog::HP::Network::NotFound) do
      HP[:network].remove_router_interface(0, '1111111111').body
    end

  end

  # cleanup
  # remove_router_interface method removes the port
  #HP[:network].delete_port(@port_id)
  HP[:network].delete_network(@network_id)

end
