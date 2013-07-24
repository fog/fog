Shindo.tests('Fog::Compute::RackspaceV2 | keypairs', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  name = Fog::Mock.random_letters(32)

  tests("success") do
    tests("#create").succeeds do
      service.keypairs.create({:name => name})
    end

    tests("#all").succeeds do
      service.keypairs.all
    end

    tests("#get").succeeds do
      service.keypairs.get(name)
    end

    tests("#delete").succeeds do
      service.keypairs.destroy(name)
    end
  end

  tests('failure') do
    tests("failed_get").raises(Fog::Compute::RackspaceV2::NotFound) do
      service.keypairs.get(Fog::Mock.random_letters(32))
    end

    tests("failed_delete").raises(Fog::Compute::RackspaceV2::NotFound) do
      service.keypairs.destroy(Fog::Mock.random_letters(32))
    end
  end
end
