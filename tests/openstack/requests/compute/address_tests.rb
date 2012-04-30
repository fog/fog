Shindo.tests('Fog::Compute[:openstack] | address requests', ['openstack']) do
  # clean the servers
=begin  
  @servers = Fog::Compute[:openstack].servers.each do |server|
    Fog::Compute[:openstack].list_all_addresses(server.id).body['floating_ips'].each do |ip_add|
      Fog::Compute[:openstack].release_address(ip_add['id'])
    end

    Fog::Compute[:openstack].delete_server(server.id)
  end
=end

  @server = Fog::Compute[:openstack].create_server("shindo_test_server", Fog::Compute[:openstack].list_images.body['images'].last['links'].first['href'], Fog::Compute[:openstack].list_flavors.body['flavors'].first['links'].first['href'])

  @address_format = {
    "instance_id" => NilClass,
    "ip" => String,
    "fixed_ip" => NilClass,
    "id" => Integer,
    "pool" => String
  }

  tests('success') do
    tests('#allocate_address').formats({"floating_ip" => @address_format}) do
      Fog::Compute[:openstack].allocate_address.body
    end

    tests('#list_all_addresses').formats({"floating_ips" => [@address_format]}) do
      Fog::Compute[:openstack].list_all_addresses.body
    end

    tests('#get_address(address_id)').formats({"floating_ip" => @address_format}) do
      address_id = Fog::Compute[:openstack].addresses.all.first.id
      Fog::Compute[:openstack].get_address(address_id).body
    end

    Fog::Compute[:openstack].servers.get(@server.body['server']['id']).wait_for { ready? }

    tests('#associate_address(server_id, ip_address)').succeeds do
      address_ip = Fog::Compute[:openstack].addresses.all.first.ip
      Fog::Compute[:openstack].associate_address(@server.body['server']['id'], address_ip).body
    end

    tests('#disassociate_address(server_id, ip_address)').succeeds do
      address_ip = Fog::Compute[:openstack].addresses.all.first.ip
      Fog::Compute[:openstack].disassociate_address(@server.body['server']['id'], address_ip).body
    end
  end
end
