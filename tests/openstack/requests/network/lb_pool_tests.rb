Shindo.tests('Fog::Network[:openstack] | lb_pool requests', ['openstack']) do

  @lb_pool_format = {
    'id'                 => String,
    'subnet_id'          => String,
    'protocol'           => String,
    'lb_method'          => String,
    'name'               => String,
    'description'        => String,
    'health_monitors'    => Array,
    'members'            => Array,
    'status'             => String,
    'admin_state_up'     => Fog::Boolean,
    'vip_id'             => Fog::Nullable::String,
    'tenant_id'          => String,
    'active_connections' => Fog::Nullable::Integer,
    'bytes_in'           => Fog::Nullable::Integer,
    'bytes_out'          => Fog::Nullable::Integer,
    'total_connections'  => Fog::Nullable::Integer
  }

  @lb_pool_stats_format = {
    'active_connections' => Integer,
    'bytes_in'           => Integer,
    'bytes_out'          => Integer,
    'total_connections'  => Integer
  }

  tests('success') do
    tests('#create_lb_pool').formats({'pool' => @lb_pool_format}) do
      subnet_id = 'subnet_id'
      protocol = 'HTTP'
      lb_method = 'ROUND_ROBIN'
      attributes = {:name => 'test-pool', :description => 'Test Pool',
                    :admin_state_up => true, :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_lb_pool(subnet_id, protocol, lb_method, attributes).body
    end

    tests('#list_lb_pools').formats({'pools' => [@lb_pool_format]}) do
      Fog::Network[:openstack].list_lb_pools.body
    end

    tests('#get_lb_pool').formats({'pool' => @lb_pool_format}) do
      lb_pool_id = Fog::Network[:openstack].lb_pools.all.first.id
      Fog::Network[:openstack].get_lb_pool(lb_pool_id).body
    end

    tests('#get_lb_pool_stats').formats({'stats' => @lb_pool_stats_format}) do
      lb_pool_id = Fog::Network[:openstack].lb_pools.all.first.id
      Fog::Network[:openstack].get_lb_pool_stats(lb_pool_id).body
    end

    tests('#update_lb_pool').formats({'pool' => @lb_pool_format}) do
      lb_pool_id = Fog::Network[:openstack].lb_pools.all.first.id
      attributes = {:name => 'new-test-pool', :description => 'New Test Pool',
                    :lb_method => 'LEAST_CONNECTIONS', :admin_state_up => false}
      Fog::Network[:openstack].update_lb_pool(lb_pool_id, attributes).body
    end

    tests('#delete_lb_pool').succeeds do
      lb_pool_id = Fog::Network[:openstack].lb_pools.all.first.id
      Fog::Network[:openstack].delete_lb_pool(lb_pool_id)
    end
  end

  tests('failure') do
    tests('#get_lb_pool').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_lb_pool(0)
    end

    tests('#update_lb_pool').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_lb_pool(0, {})
    end

    tests('#delete_lb_pool').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_lb_pool(0)
    end
  end

end
