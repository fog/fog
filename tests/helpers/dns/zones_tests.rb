def zones_tests(connection, params = {}, mocks_implemented = true)

  params = {:domain => 'fogzonestests.com'}.merge!(params)

  collection_tests(connection.zones, params, mocks_implemented)

end
