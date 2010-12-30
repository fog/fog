def zone_tests(connection, params = {}, mocks_implemented = true)

  params = {:domain => 'fogzonetests.com'}.merge!(params)

  model_tests(connection.zones, params, mocks_implemented)

end
