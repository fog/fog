Shindo.tests('Fog::Compute::RackspaceV2 | flavor_tests', ['rackspace']) do

  flavor_format = {
    'id' => String,
    'name' => String,
    'ram' => Fog::Nullable::Integer,
    'disk' => Fog::Nullable::Integer,
    'vcpus' => Fog::Nullable::Integer,
    'links' => [{
      'rel' => String,
      'href' => String
    }]
  }

  list_flavor_format = {
    'flavors' => [flavor_format]
  }

  get_flavor_format = {
    'flavor' => flavor_format.merge({
      'OS-FLV-EXT-DATA:ephemeral' => Integer,
      'rxtx_factor' => Float,
      'swap' => Integer
    })
  }

  service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  flavor_id = nil

  tests('success') do
    tests('#list_flavors').formats(list_flavor_format) do
      body = service.list_flavors.body
      flavor_id = body['flavors'][0]['id']
      body
    end

    tests('#list_flavors_detail').formats(list_flavor_format) do
      body = service.list_flavors_detail.body
      flavor_id = body['flavors'][0]['id']
      body
    end

    tests('#get_flavor').formats(get_flavor_format) do
      service.get_flavor(flavor_id).body
    end
  end
end
