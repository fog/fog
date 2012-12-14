Shindo.tests('Fog::Network[:openstack] | floatingip requests', ['openstack']) do

  @floatingip_format = {
    'id'                  => String,
    'floating_network_id' => String,
    'port_id'             => Fog::Nullable::String,
    'tenant_id'           => Fog::Nullable::String,
    'fixed_ip_address'    => Fog::Nullable::String,
  }





  require '/home/kaneko/.rbenv/versions/1.9.3-p327/lib/ruby/gems/1.9.1/gems/awesome_print-1.1.0/lib/awesome_print.rb'

  tests('success') do
    tests('#create_floatingip').formats({'floatingip' => @floatingip_format}) do
      floating_network_id = 'f0000000-0000-0000-0000-000000000000'
      attributes = {:port_id => 'p0000000-0000-0000-0000-000000000000',
                    :tenant_id => 't0000000-0000-0000-0000-000000000000',
                    :fixed_ip_address => '192.168.0.1' }
      Fog::Network[:openstack].create_floatingip(floating_network_id, attributes).body
    end

    tests('#list_floatingip').formats({'floatingips' => [@floatingip_format]}) do
      Fog::Network[:openstack].list_floatingips.body
    end

    tests('#get_floatingip').formats({'floatingip' => @floatingip_format}) do
      floating_network_id = Fog::Network[:openstack].floatingips.all.first.id
      Fog::Network[:openstack].get_floatingip(floating_network_id).body
    end

    tests('#update_floatingip').formats({'floatingip' => @floatingip_format}) do
      floating_network_id = Fog::Network[:openstack].floatingips.all.first.id
      attributes = {:port_id => 'p0000000-0000-0000-0000-000000000000',
                    :tenant_id => 't0000000-0000-0000-0000-000000000000',
                    :fixed_ip_address => '192.168.0.1' }
      Fog::Network[:openstack].update_floatingip(floating_network_id, attributes).body
    end

    tests('#delete_floatingip').succeeds do
      floating_network_id = Fog::Network[:openstack].floatingips.all.first.id
      Fog::Network[:openstack].delete_floatingip(floating_network_id)
    end

  end

  tests('failure') do
    tests('#get_floatingip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_floatingip(0)
    end

    tests('#update_floatingip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].update_floatingip(0, {})
    end

    tests('#delete_floatingip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_floatingip(0)
    end

  end

end
