Shindo.tests('Fog::Compute::RackspaceV2 | flavors', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  tests("success") do
    tests("#all").succeeds do
      service.flavors.all
    end

    tests("#get").succeeds do
      service.flavors.get(service.flavors.first.id)
    end
  end

  tests("failure").returns(nil) do
    service.flavors.get(Fog::Rackspace::MockData::NOT_FOUND_ID)
  end
end
