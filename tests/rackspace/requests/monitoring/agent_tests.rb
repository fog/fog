Shindo.tests('Fog::Rackspace::Monitoring | agent_tests', ['rackspace','rackspace_monitoring']) do

  account = Fog::Rackspace::Monitoring.new
  agent_token = nil
  options = { "label" => "Bar" }
  values_format = Hash

  tests('success') do
    tests('#create new agent token').formats(DATA_FORMAT) do
      response = account.create_agent_token(options).data
      agent_token = response[:headers]["X-Object-ID"]
      response
    end
    tests('#list agent tokens').formats(LIST_HEADERS_FORMAT) do
      account.list_agent_tokens().data[:headers]
    end
    tests("#list_agents") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.list_agents.body }
    end
    tests("#get_agent") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_agent("agent_id").body }
    end

    tests('#get agent token').formats(LIST_HEADERS_FORMAT) do
      account.get_agent_token(agent_token).data[:headers]
    end
    tests('#delete agent token').formats(DELETE_HEADERS_FORMAT) do
      account.delete_agent_token(agent_token).data[:headers]
    end
    tests("#get_cpus_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_cpus_info("agent_id").body }
    end
    tests("#get_disks_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_disks_info("agent_id").body }
    end
    tests("#get_filesystems_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_filesystems_info("agent_id").body }
    end
    tests("#get_logged_in_user_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_logged_in_user_info("agent_id").body }
    end
    tests("#get_memory_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_memory_info("agent_id").body }
    end
    tests("#get_network_interfaces_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_network_interfaces_info("agent_id").body }
    end
    tests("#get_processes_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_processes_info("agent_id").body }
    end
    tests("#get_system_info") do
    	data_matches_schema(values_format, {:allow_extra_keys => true}) { account.get_system_info("agent_id").body }
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
    tests('#fail to connect to agent(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.get_cpus_info(-1)
    end
    tests('#fail to get agent (-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.get_agent(-1)
    end
  end
end
