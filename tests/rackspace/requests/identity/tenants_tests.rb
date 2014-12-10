Shindo.tests('Fog::Rackspace::Identity | tenants', ['rackspace']) do

  pending if Fog.mock?

  TENANTS_FORMATS = {
    'tenants' => [{
      'id' => String,
      'name' => String,
      'description' => Fog::Nullable::String,
      'enabled' => Fog::Nullable::Boolean
    }]
  }

  service = Fog::Rackspace::Identity.new

  tests('success') do
    tests('#list_tenants').formats(TENANTS_FORMATS) do
      service.list_tenants().body
    end
  end
end
