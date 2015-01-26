Shindo.tests('Fog::Compute[:openstack] | address requests', ['openstack']) do

  compute = Fog::Compute[:openstack]

  @server_id = compute.create_server("shindo_test_server", get_image_ref, get_flavor_ref).body['server']['id']

  @address_format = {
    "instance_id" => NilClass,
    "ip" => String,
    "fixed_ip" => NilClass,
    "id" => Integer,
    "pool" => String
  }

  @address_pools_format = {
    "name" => String
  }

  tests('success') do

    tests('#allocate_address').formats({"floating_ip" => @address_format}) do
      data = compute.allocate_address.body
      @address_id = data['floating_ip']['id']
      @address_ip = data['floating_ip']['ip']
      data
    end

    tests('#list_all_addresses').formats({"floating_ips" => [@address_format]}) do
      compute.list_all_addresses.body
    end

    tests('#get_address(address_id)').formats({"floating_ip" => @address_format}) do
      compute.get_address(@address_id).body
    end

    tests('#list_address_pools').formats({"floating_ip_pools" => [@address_pools_format]}) do
      compute.list_address_pools.body
    end

    compute.servers.get(@server_id).wait_for { ready? }

    tests('#associate_address(server_id, ip_address)').succeeds do
      compute.associate_address(@server_id, @address_ip).body
    end

    tests('#disassociate_address(server_id, ip_address)').succeeds do
      compute.disassociate_address(@server_id, @address_ip).body
    end

    tests('#release_address(ip_address)').succeeds do
      compute.release_address(@address_id)
    end

  end

  compute.delete_server(@server_id)

end
