Shindo.tests('Fog::Rackspace::Monitoring | list_overview_tests', ['rackspace']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  tests('success') do
    tests('#get list overview').formats(OVERVIEW_HEADERS_FORMAT) do
      account.list_overview().data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list overview').raises(Fog::Rackspace::Monitoring::NoMethodError) do
      account.list_overview(-1)
    end
  end
end
