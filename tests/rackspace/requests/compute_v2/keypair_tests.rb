Shindo.tests('Fog::Compute::RackspaceV2 | keypair_tests', ['rackspace']) do

  keypair_format = {
    'name'        => String,
    'public_key'  => String,
    'fingerprint' => String,
  }

  create_keypair_format = {
    'keypair' => keypair_format.merge({
        'user_id'     => String,
        'private_key' => String
    })
  }

  list_keypair_format = {
    'keypairs' => [ 'keypair' => keypair_format ]
  }

  get_keypair_format = {
    'keypair' => keypair_format
  }

  service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  keypair_name = Fog::Mock.random_letters(32)

  tests('success') do
    tests('#create_keypair').formats(create_keypair_format) do
      service.create_keypair(keypair_name).body
    end

    tests('#list_keypairs').formats(list_keypair_format) do
      service.list_keypairs.body
    end

    tests('#get_keypair').formats(get_keypair_format) do
      service.get_keypair(keypair_name).body
    end

    tests('#delete_keypair') do
      service.delete_keypair(keypair_name).body
    end
  end

  unknown_keypair_name = Fog::Mock.random_letters(32)
  tests('failure') do
    tests('#get_unknown_keypair').raises(Fog::Compute::RackspaceV2::NotFound) do
      service.get_keypair(unknown_keypair_name).body
    end

    tests('#delete_unknown_keypair').raises(Fog::Compute::RackspaceV2::NotFound) do
      service.delete_keypair(unknown_keypair_name).body
    end
  end
end
