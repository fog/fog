Shindo.tests('Fog::Rackspace::Database | flavor_tests', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new

  tests('success') do
    tests('#list_flavors_details').formats(LIST_FLAVORS_FORMAT) do
      service.list_flavors().body
    end

    tests('#get_flavor(1)').formats(GET_FLAVOR_FORMAT) do
      service.get_flavor(1).body
    end
  end
end
