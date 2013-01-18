Shindo.tests('Fog::Compute[:openstack] | keypair requests', ['openstack']) do

  @keypair_format = {
    "public_key" => String,
    "private_key" => String,
    "user_id" => String,
    "name" => String,
    "fingerprint" => String
  }

  @keypair_list_format = {
    "public_key" => String,
    "name" => String,
    "fingerprint" => String
  }

  tests('success') do
    tests('#create_key_pair((key_name, public_key = nil))').formats({"keypair" => @keypair_format}) do
      Fog::Compute[:openstack].create_key_pair('from_shindo_test').body
    end

    tests('#list_key_pairs').formats({"keypairs" => [{"keypair" => @keypair_list_format}]}) do
      Fog::Compute[:openstack].list_key_pairs.body
    end

    tests('#delete_key_pair(key_name)').succeeds do
      Fog::Compute[:openstack].delete_key_pair('from_shindo_test')
    end
  end
end
