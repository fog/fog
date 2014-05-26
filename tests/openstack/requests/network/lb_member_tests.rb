Shindo.tests('Fog::Network[:openstack] | lb_member requests', ['openstack']) do

  @lb_member_format = {
    'id'             => String,
    'pool_id'        => String,
    'address'        => String,
    'protocol_port'  => Integer,
    'weight'         => Integer,
    'status'         => String,
    'admin_state_up' => Fog::Boolean,
    'tenant_id'      => String,
  }

  tests('success') do
    tests('#create_lb_member').formats({'member' => @lb_member_format}) do
      pool_id = 'pool_id'
      address = '10.0.0.1'
      protocol_port = 80
      weight = 100
      attributes = {:admin_state_up => true, :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_lb_member(pool_id, address, protocol_port, weight, attributes).body
    end

    tests('#list_lb_members').formats({'members' => [@lb_member_format]}) do
      Fog::Network[:openstack].list_lb_members.body
    end

    tests('#get_lb_member').formats({'member' => @lb_member_format}) do
      lb_member_id = Fog::Network[:openstack].lb_members.all.first.id
      Fog::Network[:openstack].get_lb_member(lb_member_id).body
    end

    tests('#update_lb_member').formats({'member' => @lb_member_format}) do
      lb_member_id = Fog::Network[:openstack].lb_members.all.first.id
      attributes = {:pool_id => 'new_pool_id', :weight => 50,
                    :admin_state_up => false}
      Fog::Network[:openstack].update_lb_member(lb_member_id, attributes).body
    end

    tests('#delete_lb_member').succeeds do
      lb_member_id = Fog::Network[:openstack].lb_members.all.first.id
      Fog::Network[:openstack].delete_lb_member(lb_member_id)
    end
  end

  tests('failure') do
    tests('#get_lb_member').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_lb_member(0)
    end

    tests('#update_lb_member').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_lb_member(0, {})
    end

    tests('#delete_lb_member').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_lb_member(0)
    end
  end

end
