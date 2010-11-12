def servers_tests(connection, params, mocks_implemented = true)

  collection_tests(connection.servers, params, mocks_implemented) do
    @instance.wait_for { ready? }
  end

end
