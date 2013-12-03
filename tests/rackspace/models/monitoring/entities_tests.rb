Shindo.tests('Fog::Rackspace::Monitoring | entities', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i.to_s}", :ip_addresses => {:default => "127.0.0.1"} }
  collection_tests(service.entities, options, false) do

  end

  tests('overview').succeeds do
    service.entities.overview
  end

end
