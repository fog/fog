Shindo.tests('Fog::Rackspace::Monitoring | list_tests', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  check_id = account.create_check(entity_id,CHECK_CREATE_OPTIONS).data[:headers]["X-Object-ID"]
  tests('success') do
    tests('#get list of checks').formats(LIST_HEADERS_FORMAT) do
      account.list_checks(entity_id).data[:headers]
    end
    tests('#get list of check types').formats(LIST_HEADERS_FORMAT) do
      account.list_check_types().data[:headers]
    end
    tests('#get list of entities').formats(LIST_HEADERS_FORMAT) do
      account.list_entities().data[:headers]
    end
    tests('#get list of metrics').formats(LIST_HEADERS_FORMAT) do
     account.list_metrics(entity_id,check_id).data[:headers]
    end
    tests('#get overview list').formats(LIST_HEADERS_FORMAT) do
      account.list_overview().data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list checks').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.list_checks(-1)
    end
    tests('#fail to list check types').raises(Fog::Rackspace::Monitoring::ArgumentError) do
      account.list_check_types(-1)
    end
    tests('#fail to list entities').raises(Fog::Rackspace::Monitoring::ArgumentError) do
      account.list_entities(-1)
    end
    # This test has been put on hold due to a bug that incorrectly returns 200 OK to this request
    #tests('#fail to list metrics').raises(Fog::Rackspace::Monitoring::NotFound) do
      #account.list_metrics(-1,-1)
    #end
    tests('#fail to list overview').raises(Fog::Rackspace::Monitoring::NoMethodError) do
      account.list_overview(-1)
    end
  end
  account.delete_check(entity_id,check_id)
  account.delete_entity(entity_id)
end
