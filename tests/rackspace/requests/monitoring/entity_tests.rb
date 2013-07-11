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
end
__END__
  tests('failure') do
    tests('#create new entity(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      response = account.create_entity(:label => "").data
      puts "I made it this far"
      pp response
      puts "All done now"
    end
    tests('#update entity(-1)').raises(Fog::Rackspace::Monitoring::Notfound) do
      entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"] #setup
      options = { :testing => "Bar" }
      response = account.update_entity(entity_id,options)
      puts ""
      pp response
      account.delete_entity(entity_id) #cleanup
      response
    end
    tests('#delete entity(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_entity(-1)
    end
  end
end
