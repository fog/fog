Shindo.tests('Fog::Rackspace::Monitoring | list_checks_tests', ['rackspace']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  tests('success') do
    tests('#get list of checks').formats(LIST_HEADERS_FORMAT) do
      account.list_checks(entity_id).data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list checks').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.list_checks(-1)
    end
  end
  account.delete_entity(entity_id)
end
