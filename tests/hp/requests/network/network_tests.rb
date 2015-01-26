Shindo.tests('HP::Network | networking network requests', ['hp',  'networking', 'network']) do

  @network_format = {
    'id'              => String,
    'name'            => Fog::Nullable::String,
    'tenant_id'       => String,
    'status'          => String,
    'subnets'         => Array,
    'router:external' => Fog::Boolean,
    'admin_state_up'  => Fog::Boolean,
    'shared'          => Fog::Boolean
  }

  tests('success') do

    @network_id = nil

    tests('#create_network').formats(@network_format) do
      attributes = {:name => 'my_network', :admin_state_up => true, :shared => false}
      data = HP[:network].create_network(attributes).body['network']
      @network_id = data['id']
      data
    end

    tests('#list_networks').formats({'networks' => [@network_format]}) do
      HP[:network].list_networks.body
    end

    tests("#get_network(#{@network_id})").formats({'network' => @network_format}) do
      HP[:network].get_network(@network_id).body
    end

    tests("#update_network(#{@network_id})").formats({'network' => @network_format}) do
      attributes = {:name => 'my_network_upd', :shared => false, :admin_state_up => true}
      HP[:network].update_network(@network_id, attributes).body
    end

    tests("#delete_network(#{@network_id})").succeeds do
      HP[:network].delete_network(@network_id)
    end
  end

  tests('failure') do
    tests('#get_network(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_network(0)
    end

    tests('#update_network(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].update_network(0, {})
    end

    tests('#delete_network(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_network(0)
    end
  end

end
