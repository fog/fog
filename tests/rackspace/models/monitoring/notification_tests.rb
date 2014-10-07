Shindo.tests('Fog::Rackspace::Monitoring | notification', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i.to_s}", :type => "email", :details => {:address => "test@test.com"} }

  model_tests(service.notifications, options, false) do

    tests('#update').succeeds do
      new_label = "new_label_#{Time.now.to_i.to_s}"
      @instance.label = new_label
      @instance.save
      @instance.label = nil # blank out label just to make sure
      @instance.reload
      returns(new_label) { @instance.label }
    end
  end

end
