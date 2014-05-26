Shindo.tests('Fog::Network[:openstack] | lb_vip requests', ['openstack']) do

  @lb_vip_format = {
    'id'                  => String,
    'subnet_id'           => String,
    'pool_id'             => String,
    'protocol'            => String,
    'protocol_port'       => Integer,
    'name'                => String,
    'description'         => String,
    'address'             => String,
    'port_id'             => String,
    'session_persistence' => Hash,
    'connection_limit'    => Integer,
    'status'              => String,
    'admin_state_up'      => Fog::Boolean,
    'tenant_id'           => String,
  }

  tests('success') do
    tests('#create_lb_vip').formats({'vip' => @lb_vip_format}) do
      subnet_id = 'subnet_id'
      pool_id = 'pool_id'
      protocol = 'HTTP'
      protocol_port = 80
      attributes = {:name => 'test-vip', :description => 'Test VIP',
                    :address => '10.0.0.1', :connection_limit => 10,
                    :session_persistence => { "cookie_name" => "COOKIE_NAME", "type" => "APP_COOKIE" },
                    :admin_state_up => true, :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_lb_vip(subnet_id, pool_id, protocol, protocol_port, attributes).body
    end

    tests('#list_lb_vips').formats({'vips' => [@lb_vip_format]}) do
      Fog::Network[:openstack].list_lb_vips.body
    end

    tests('#get_lb_vip').formats({'vip' => @lb_vip_format}) do
      lb_vip_id = Fog::Network[:openstack].lb_vips.all.first.id
      Fog::Network[:openstack].get_lb_vip(lb_vip_id).body
    end

    tests('#update_lb_vip').formats({'vip' => @lb_vip_format}) do
      lb_vip_id = Fog::Network[:openstack].lb_vips.all.first.id
      attributes = {:pool_id => 'new_pool_id', :name => 'new-test-vip',
                    :description => 'New Test VIP', :connection_limit => 5,
                    :session_persistence => { "type" => "HTTP_COOKIE" },
                    :admin_state_up => false}
      Fog::Network[:openstack].update_lb_vip(lb_vip_id, attributes).body
    end

    tests('#delete_lb_vip').succeeds do
      lb_vip_id = Fog::Network[:openstack].lb_vips.all.first.id
      Fog::Network[:openstack].delete_lb_vip(lb_vip_id)
    end
  end

  tests('failure') do
    tests('#get_lb_vip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_lb_vip(0)
    end

    tests('#update_lb_vip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_lb_vip(0, {})
    end

    tests('#delete_lb_vip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_lb_vip(0)
    end
  end

end
