Shindo.tests('Fog::Rackspace::Databases | flavors', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new

  tests("success") do
    tests("#all").succeeds do
      service.flavors.all
    end

    tests("#get").succeeds do
      service.flavors.get(1)
    end
  end

  tests("failure").returns(nil) do
    service.flavors.get('some_random_identity')
  end
end
