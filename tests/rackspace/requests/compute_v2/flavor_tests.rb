Shindo.tests('Fog::Compute::RackspaceV2 | flavor_tests', ['rackspace']) do

  pending if Fog.mocking?

  FLAVOR_FORMAT = {
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

  LIST_FLAVOR_FORMAT = {
    'flavors' => [FLAVOR_FORMAT]
  }

  GET_FLAVOR_FORMAT = {
    'flavor' => FLAVOR_FORMAT.merge({
      'OS-FLV-DISABLED:disabled' => Fog::Boolean,
      'rxtx_factor' => Float,
      'swap' => Integer
    })
  }

  service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  flavor_id = nil

  tests('success') do
    tests('#list_flavors').formats(LIST_FLAVOR_FORMAT) do
      body = service.list_flavors.body
      flavor_id = body['flavors'][0]['id']
      body
    end

    tests('#get_flavor').formats(GET_FLAVOR_FORMAT) do
      service.get_flavor(flavor_id).body
    end
  end
end
