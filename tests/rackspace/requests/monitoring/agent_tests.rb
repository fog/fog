Shindo.tests('Fog::Rackspace::Monitoring | agent_tests', ['rackspace','rackspace_monitoring']) do

  account = Fog::Rackspace::Monitoring.new
  agent_token = nil
  options = { "label" => "Bar" }
  tests('success') do
    tests('#create new agent token').formats(DATA_FORMAT) do
      response = account.create_agent_token(options).data
      agent_token = response[:headers]["X-Object-ID"]
      response
    end
    tests('#list agent tokens').formats(LIST_HEADERS_FORMAT) do
      account.list_agent_tokens().data[:headers]
    end
    tests('#get agent token').formats(LIST_HEADERS_FORMAT) do
      account.get_agent_token(agent_token).data[:headers]
    end
    tests('#delete agent token').formats(DELETE_HEADERS_FORMAT) do
      account.delete_agent_token(agent_token).data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to create agent token(-1)').raises(TypeError) do
      account.create_agent_token(-1)
    end
    tests('#fail to get agent token(-1)').raises(TypeError) do
      account.create_agent_token(-1)
    end
    tests('#fail to delete agent token(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_agent_token(-1)
    end
  end
end
