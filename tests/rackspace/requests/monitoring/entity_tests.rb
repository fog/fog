Shindo.tests('Fog::Rackspace::Monitoring | entity_tests', ['rackspace','rackspace_monitoring']) do
  account = Fog::Rackspace::Monitoring.new
  entity_id = nil
  tests('success') do
    tests('#create new entity').formats(DATA_FORMAT) do
      response = account.create_entity(:label => "Foo").data
      @entity_id = response[:headers]["X-Object-ID"]
      response
    end
    tests('#get entity').formats(LIST_HEADERS_FORMAT) do
      account.get_entity(@entity_id).data[:headers]
    end
    tests('#update entity').formats(DATA_FORMAT) do
      options = { :metadata => {:testing => "Bar" }}
      account.update_entity(@entity_id,options).data
    end
    tests('#delete entity').formats(DELETE_DATA_FORMAT) do
      account.delete_entity(@entity_id).data
    end
  end
  tests('failure') do
    tests('#create new entity(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_entity(:label => "")
    end
    tests('#get entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.get_entity(-1)
    end
    tests('#update invalid entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      options = { :metadata => {:testing => "Bar" }}
      response = account.update_entity(-1,options)
    end
    tests('#delete entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_entity(-1)
    end
  end
end
