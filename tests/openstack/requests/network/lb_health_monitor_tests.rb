Shindo.tests('Fog::Network[:openstack] | lb_health_monitor requests', ['openstack']) do

  @lb_health_monitor_format = {
    'id'             => String,
    'type'           => String,
    'delay'          => Integer,
    'timeout'        => Integer,
    'max_retries'    => Integer,
    'http_method'    => String,
    'url_path'       => String,
    'expected_codes' => String,
    'status'         => String,
    'admin_state_up' => Fog::Boolean,
    'tenant_id'      => String,
  }

  tests('success') do
    before do
      @lb_pool = Fog::Network[:openstack].lb_pools.create(:subnet_id => 'subnet_id',
                                                          :protocol => 'HTTP',
                                                          :lb_method => 'ROUND_ROBIN')
    end

    after do
      @lb_pool.destroy
    end

    tests('#create_lb_health_monitor').formats({'health_monitor' => @lb_health_monitor_format}) do
      type = 'PING'
      delay = 1
      timeout = 5
      max_retries = 10
      attributes = {:http_method => 'GET', :url_path => '/', :expected_codes => '200, 201',
                    :admin_state_up => true, :tenant_id => 'tenant_id'}
      Fog::Network[:openstack].create_lb_health_monitor(type, delay, timeout, max_retries, attributes).body
    end

    tests('#list_lb_health_monitors').formats({'health_monitors' => [@lb_health_monitor_format]}) do
      Fog::Network[:openstack].list_lb_health_monitors.body
    end

    tests('#get_lb_health_monitor').formats({'health_monitor' => @lb_health_monitor_format}) do
      lb_health_monitor_id = Fog::Network[:openstack].lb_health_monitors.all.first.id
      Fog::Network[:openstack].get_lb_health_monitor(lb_health_monitor_id).body
    end

    tests('#update_lb_health_monitor').formats({'health_monitor' => @lb_health_monitor_format}) do
      lb_health_monitor_id = Fog::Network[:openstack].lb_health_monitors.all.first.id
      attributes = {:delay => 5, :timeout => 10, :max_retries => 20,
                    :http_method => 'POST', :url_path => '/varz', :expected_codes => '200',
                    :admin_state_up => false}
      Fog::Network[:openstack].update_lb_health_monitor(lb_health_monitor_id, attributes).body
    end

    tests('#associate_lb_health_monitor').succeeds do
      lb_health_monitor_id = Fog::Network[:openstack].lb_health_monitors.all.first.id
      Fog::Network[:openstack].associate_lb_health_monitor(@lb_pool.id, lb_health_monitor_id)
    end

    tests('#disassociate_lb_health_monitor').succeeds do
      lb_health_monitor_id = Fog::Network[:openstack].lb_health_monitors.all.first.id
      Fog::Network[:openstack].disassociate_lb_health_monitor(@lb_pool.id, lb_health_monitor_id)
    end

    tests('#delete_lb_health_monitor').succeeds do
      lb_health_monitor_id = Fog::Network[:openstack].lb_health_monitors.all.first.id
      Fog::Network[:openstack].delete_lb_health_monitor(lb_health_monitor_id)
    end
  end

  tests('failure') do
    tests('#get_lb_health_monitor').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_lb_health_monitor(0)
    end

    tests('#update_lb_health_monitor').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_lb_health_monitor(0, {})
    end

    tests('#associate_lb_health_monitor').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].associate_lb_health_monitor(0, 0)
    end

    tests('#disassociate_lb_health_monitor').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].disassociate_lb_health_monitor(0, 0)
    end

    tests('#delete_lb_health_monitor').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_lb_health_monitor(0)
    end
  end

end
