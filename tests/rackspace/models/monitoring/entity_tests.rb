Shindo.tests('Fog::Rackspace::Monitoring | entity', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  options = { :label => "fog_#{Time.now.to_i.to_s}", :ip_addresses => {:default => "127.0.0.1"} }
  model_tests(service.entities, options, false) do

    tests('#update').succeeds do
      new_label = "new_label_#{Time.now.to_i.to_s}"
      @instance.label = new_label
      @instance.save
      @instance.label = nil # blank out label just to make sure
      @instance.reload
      returns(new_label) { @instance.label }
    end

    tests('#checks').succeeds do
      @instance.checks
    end

    tests('#alarms').succeeds do
      @instance.alarms
    end
  end

end
