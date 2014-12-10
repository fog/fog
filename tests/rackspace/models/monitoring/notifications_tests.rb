Shindo.tests('Fog::Rackspace::Monitoring | notifications', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i.to_s}", :type => "email", :details => {:address => "test@test.com"} }
  collection_tests(service.notifications, options, false) do

  end

end
