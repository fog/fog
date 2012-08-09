Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => 2,
    :image_id => '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001'
  }

  model_tests(service.servers, options, false) do
    @instance.wait_for { ready? }
    tests('#reboot("SOFT")').succeeds do
      @instance.reboot('SOFT')
      returns('REBOOT') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('#reboot("HARD")').succeeds do
      @instance.reboot('HARD')
      returns('HARD_REBOOT') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('#rebuild').succeeds do
      @instance.rebuild('5cebb13a-f783-4f8c-8058-c4182c724ccd')
      returns('REBUILD') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for { state == 'VERIFY_RESIZE' }
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end

    @instance.wait_for { ready? }
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for { state == 'VERIFY_RESIZE' }
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end

    @instance.wait_for { ready? }
    tests('#change_admin_password').succeeds do
      @instance.change_admin_password('somerandompassword')
      returns('PASSWORD') { @instance.state }
      returns('somerandompassword') { @instance.password }
    end

    @instance.wait_for { ready? }
  end
end
