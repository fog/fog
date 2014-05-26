Shindo.tests('Fog::Rackspace::Monitoring | agent token', ['rackspace','rackspace_monitoring']) do
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i}" }
  model_tests(service.agent_tokens, options, false) do

  end

end
