Shindo.tests('Fog::Compute::RackspaceV2 | key_pairs', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  name  = Fog::Mock.random_letters(32)
  key   = nil

  tests("API access") do
    begin
        tests("create").succeeds do
          key = service.key_pairs.create({:name => name})
        end

        tests("list all").succeeds do
          service.key_pairs.all
        end

        tests("get").succeeds do
          service.key_pairs.get(name)
        end

        tests("delete").succeeds do
          key = nil if service.key_pairs.destroy(name)
          key == nil
        end

        tests("get unknown").returns(nil) do
          service.key_pairs.get(Fog::Mock.random_letters(32))
        end

        tests("delete unknown").raises(Fog::Compute::RackspaceV2::NotFound) do
            service.key_pairs.destroy(Fog::Mock.random_letters(32))
        end

        tests("create again after delete").succeeds do
          key = service.key_pairs.create({:name => name})
        end

        tests("create already existing").raises(Fog::Compute::RackspaceV2::ServiceError) do
          service.key_pairs.create({:name => name})
        end

    ensure
        key.destroy if key
    end

  end
end
