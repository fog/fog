def flavors_tests(connection, params = {}, mocks_implemented = true)

  tests('success') do

    tests("#all").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      connection.flavors.all
    end

    @identity = connection.flavors.first.identity

    tests("#get('#{@identity}')").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      connection.flavors.get(@identity)
    end

  end

  tests('failure') do

    invalid_flavor_identity = connection.flavors.first.identity.gsub(/\w/, '0')

    tests("#get('#{invalid_flavor_identity}')").returns(nil) do
      pending if Fog.mocking? && !mocks_implemented
      connection.flavors.get(invalid_flavor_identity)
    end

  end

end
