def directories_tests(connection, params = {:key => 'fogdirectoriestests'}, mocks_implemented = true)

  collection_tests(connection.directories, params, mocks_implemented)

end
