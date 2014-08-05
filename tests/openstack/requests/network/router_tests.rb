Shindo.tests('Fog::Network[:openstack] | router requests', ['openstack']) do

  @router_format = {
    :id                    => String,
    :name                  => String,
    :status                => String,
    :admin_state_up        => Fog::Boolean,
    :tenant_id             => String,
    :external_gateway_info => Fog::Nullable::Hash,
  }

  tests('success') do
    tests('#create_router').formats({'router' => @router_format}) do
      attributes = {
        :admin_state_up => true,
        :tenant_id => 'tenant_id'
      }
      Fog::Network[:openstack].create_router('router_name', attributes).body
    end

    tests('#list_routers').formats({'routers' => [@router_format]}) do
      Fog::Network[:openstack].list_routers.body
    end

    tests('#get_router').formats({'router' => @router_format}) do
      router_id = Fog::Network[:openstack].routers.all.first.id
      Fog::Network[:openstack].get_router(router_id).body
    end

    tests('#update_router').formats({'router' => @router_format}) do
      router_id = Fog::Network[:openstack].routers.all.first.id
      attributes = {
        :name => 'net_name',
        :external_gateway_info => { :network_id => 'net_id' },
        :status => 'ACTIVE',
        :admin_state_up => true
      }
      Fog::Network[:openstack].update_router(router_id, attributes).body
    end

    tests('#update_router_with_network').formats({'router' => @router_format}) do
      router_id = Fog::Network[:openstack].routers.all.first.id
      net = Fog::Network[:openstack].networks.first
      attributes = {
        :name => 'net_name',
        :external_gateway_info => net,
        :status => 'ACTIVE',
        :admin_state_up => true
      }
      Fog::Network[:openstack].update_router(router_id, attributes).body
    end

    tests('#delete_router').succeeds do
      router_id = Fog::Network[:openstack].routers.all.last.id
      Fog::Network[:openstack].delete_router(router_id)
    end
  end

  tests('failure') do
    tests('#get_router').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_router(0)
    end

    tests('#update_router').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_router(0, {})
    end

    tests('#delete_router').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_router(0)
    end
  end

end
