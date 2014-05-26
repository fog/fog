def volumes_tests(connection, params = {}, mocks_implemented = true)
  collection_tests(connection.volumes, params, mocks_implemented) do

    if !Fog.mocking? || mocks_implemented
      @instance.wait_for { ready? }
    end

  end
end

config = compute_providers[:cloudstack]

Shindo.tests("Fog::Compute[:cloudstack] | volumes", ["cloudstack"]) do
  volumes_tests(Fog::Compute[:cloudstack], config[:volume_attributes], config[:mocked])
end
