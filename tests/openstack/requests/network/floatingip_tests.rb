Shindo.tests('Fog::Network[:openstack] | floatingip requests', ['openstack']) do

  @floatingip_format = {
    'id'                  => String,
    'floating_network_id' => String,
    'port_id'             => Fog::Nullable::String,
    'tenant_id'           => Fog::Nullable::String,
    'fixed_ip_address'    => Fog::Nullable::String,
  }





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
      floatingip_id = Fog::Network[:openstack].floatingips.all.first.id
      Fog::Network[:openstack].get_floatingip(floatingip_id).body
    end

    tests('#associate_floatingip').succeeds do
      floatingip_id = Fog::Network[:openstack].floatingips.all.first.id
      port_id = 'p00000000-0000-0000-0000-000000000000'
      Fog::Network[:openstack].associate_floatingip(floatingip_id, port_id).body
    end

    tests('#disassociate_floatingip').succeeds do
      floatingip_id = Fog::Network[:openstack].floatingips.all.first.id
      Fog::Network[:openstack].disassociate_floatingip(floatingip_id).body
    end

    tests('#delete_floatingip').succeeds do
      floatingip_id = Fog::Network[:openstack].floatingips.all.first.id
      Fog::Network[:openstack].delete_floatingip(floatingip_id).body
    end

  end

  tests('failure') do
    tests('#get_floatingip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].get_floatingip(0)
    end

    tests('#delete_floatingip').raises(Fog::Network::OpenStack::NotFound) do
      Fog::Network[:openstack].delete_floatingip(0)
    end

  end

end
