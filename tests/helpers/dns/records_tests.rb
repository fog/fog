def records_tests(connection, params = {}, mocks_implemented = true)

  params = {:ip => '1.2.3.4', :name => 'www.fogrecordstests.com', :type => 'A'}.merge!(params)

  if !Fog.mocking? || mocks_implemented
    @zone = connection.zones.create(:domain => 'fogrecordstests.com')

    collection_tests(@zone.records, params, mocks_implemented)

    @zone.destroy
  end

end
