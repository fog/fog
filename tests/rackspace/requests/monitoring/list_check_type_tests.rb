Shindo.tests('Fog::Rackspace::Monitoring | list_check_type_tests', ['rackspace']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  tests('success') do
    tests('#get check types').formats(LIST_HEADERS_FORMAT) do
      account.list_check_types().data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list check types').raises(Fog::Rackspace::Monitoring::ArgumentError) do
      account.list_check_types(-1)
    end
  end
end
