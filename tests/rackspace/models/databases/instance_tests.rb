Shindo.tests('Fog::Rackspace::Databases | instance', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  options = {
    :name => "fog_instance_#{Time.now.to_i.to_s}",
    :flavor_id => 1,
    :volume_size => 1
  }

  model_tests(service.instances, options, false) do
    @instance.wait_for { ready? }
    tests('root_user_enabled before user is enabled').returns(false) do
      @instance.root_user_enabled?
    end

    @instance.wait_for { ready? }
    tests('enable_root_user sets root user and password').succeeds do
      @instance.enable_root_user
      returns(false) { @instance.root_user.nil? }
      returns(false) { @instance.root_password.nil? }
    end

    @instance.wait_for { ready? }
    tests('restarts instance').succeeds do
      @instance.restart
      returns('REBOOT') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('resizes instance').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('restarts instance').succeeds do
      @instance.resize_volume(2)
      returns('RESIZE') { @instance.state }
    end
  end
end
