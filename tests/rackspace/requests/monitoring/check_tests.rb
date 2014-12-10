Shindo.tests('Fog::Rackspace::Monitoring | check_tests', ['rackspace', 'rackspace_monitoring']) do

  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  check_id = nil
  tests('success') do
    tests('#create new check').formats(DATA_FORMAT) do
      response = account.create_check(entity_id, CHECK_CREATE_OPTIONS).data
      check_id = response[:headers]['X-Object-ID']
      response
    end
    tests('#get check').formats(LIST_HEADERS_FORMAT) do
      account.get_check(entity_id,check_id).data[:headers]
    end
    tests('#update check').formats(DATA_FORMAT) do
      options = { :label => "Bar"}
      account.update_check(entity_id,check_id,options).data
    end
    tests('#delete check').formats(DELETE_DATA_FORMAT) do
      account.delete_check(entity_id,check_id).data
    end
  end
  tests('failure') do
    tests('#create new check(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_check(entity_id, {:type => ""})
    end
    tests('#get check(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.get_check(-1, -1)
    end
    tests('#update invalid check(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      options = { :testing => "Bar" }
      response = account.update_check(-1,-1,options)
    end
    tests('#delete check(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_check(-1,-1)
    end
  end
  account.delete_entity(entity_id)
end
