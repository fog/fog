Shindo.tests('Fog::Rackspace::Monitoring | entity_tests', ['rackspace','rackspacemonitoring']) do

  pending if Fog.mocking? 
  require 'pp'
  account = Fog::Rackspace::Monitoring.new
  entity_id = nil
  tests('success') do
    tests('#create new entity').formats(DATA_FORMAT) do
      response = account.create_entity(:label => "Foo").data
      entity_id = response[:headers]["X-Object-ID"]
      response[:status] == 201 ? response : false
    end
    tests('#update entity').formats(DATA_FORMAT) do
      options = { :testing => "Bar"}
      response = account.update_entity(entity_id,options).data
      response[:status] == 204 ? response : false
    end
    tests('#delete entity').formats(DELETE_DATA_FORMAT) do
      response = account.delete_entity(entity_id).data
      response[:status] == 204 ? response : false
    end
  end
  tests('failure') do
    tests('#create new entity(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_entity(:label => "")
    end
    tests('#update invalid entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      options = { :testing => "Bar" }
      response = account.update_entity(-1,options)
    end
    tests('#delete entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_entity(-1)
    end
  end
end
