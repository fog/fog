Shindo.tests('Fog::Rackspace::Monitoring | list_entities_tests', ['rackspace']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  tests('success') do
    tests('#get list of entities').formats(CHECKS_HEADERS_FORMAT) do
      account.list_entities().data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list entities').raises(Fog::Rackspace::Monitoring::ArgumentError) do
      account.list_entities(-1)
    end
  end
end
