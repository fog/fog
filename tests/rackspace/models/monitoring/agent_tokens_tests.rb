Shindo.tests('Fog::Rackspace::Monitoring | agent tokens', ['rackspace','rackspace_monitoring']) do
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i.to_s}" }
  collection_tests(service.agent_tokens, options, false) do

  end

end
