def volumes_tests(connection, params = {}, mocks_implemented = true)

  collection_tests(connection.volumes, params, mocks_implemented) do

    if !Fog.mocking? || mocks_implemented
      @instance.wait_for { ready? }
    end

  end

end
