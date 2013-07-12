Shindo.tests('Fog::Rackspace::Monitoring | check_tests', ['rackspace','rackspacemonitoring']) do
  pending if Fog.mocking? 
  require 'pp'
  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  check_id = nil
  tests('success') do
    #tests('#create new check').formats(DATA_FORMAT) do
    tests('#create new check').raises(Fog::Rackspace::Monitoring::BadRequest) do
      puts "\nBefore"
      response = account.create_check(entity_id, {:type => "remote.dns"}).data
      puts "After"
      pp response
      puts "All Done"
      response[:status] == 201 ? response : false
    end
    ###
  end
end
__END__
    tests('#update check').formats(DATA_FORMAT) do
      options = { :testing => "Bar"}
      response = account.update_check(check_id,options).data
      response[:status] == 204 ? response : false
    end
    tests('#delete check').formats(DELETE_DATA_FORMAT) do
      response = account.delete_check(check_id).data
      response[:status] == 204 ? response : false
    end
  end
  tests('failure') do
    tests('#create new check(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_check(entity_id, {:type => ""})
    end
    tests('#update invalid check(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      options = { :testing => "Bar" }
      response = account.update_check(-1,options)
    end
    tests('#delete check(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_check(-1)
    end
  end
end
