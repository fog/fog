Shindo.tests('Fog::Compute[:openstack] | address requests', ['openstack']) do
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

    tests('#list_all_addresses(server_id)').formats({"floating_ips" => [@address_format]}) do
      Fog::Compute[:openstack].list_all_addresses("sd34234dvsdasdmlk123cdslfck1").body
    end

    tests('#get_address(address_id)').formats({"floating_ip" => @address_format}) do
      Fog::Compute[:openstack].get_address(1).body
    end

    tests('#disassociate_address(server_id, ip_address)').succeeds do
      Fog::Compute[:openstack].disassociate_address("sd34234dvsdasdmlk123cdslfck1", "192.168.27.129").body
    end
  end
end
