Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new
  cbs_service = Fog::Rackspace::BlockStorage.new

  tests('setup test network').succeeds do
    @network = service.networks.create :label => "fog_test_net_#{Time.now.to_i.to_s}", :cidr => '192.168.1.0/24'
  end

  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => rackspace_test_flavor_id(service),
    :image_id => rackspace_test_image_id(service),
    :metadata => { 'fog_test' => 'true' },
    :networks => [@network.id]
  }

  tests('ready?') do
    @server = Fog::Compute::RackspaceV2::Server.new

    tests('default in ready state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Server::ACTIVE
      @server.ready?
    end

    tests('custom ready state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Server::VERIFY_RESIZE
      @server.ready?(Fog::Compute::RackspaceV2::Server::VERIFY_RESIZE)
    end

    tests('default NOT in ready state').returns(false) do
      @server.state = Fog::Compute::RackspaceV2::Server::REBOOT
      @server.ready?
    end

    tests('custom NOT ready state').returns(false) do
      @server.state = Fog::Compute::RackspaceV2::Server::REBOOT
      @server.ready?(Fog::Compute::RackspaceV2::Server::VERIFY_RESIZE)
    end

    tests('default error state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Server::ERROR
      exception_occurred = false
      begin
        @server.ready?
      rescue Fog::Compute::RackspaceV2::InvalidServerStateException => e
        exception_occurred = true
        returns(true) {e.desired_state == Fog::Compute::RackspaceV2::Server::ACTIVE }
        returns(true) {e.current_state == Fog::Compute::RackspaceV2::Server::ERROR }
      end
      exception_occurred
    end

    tests('custom error state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Server::ACTIVE
      exception_occurred = false
      begin
        @server.ready?(Fog::Compute::RackspaceV2::Server::VERIFY_RESIZE, Fog::Compute::RackspaceV2::Server::ACTIVE)
      rescue Fog::Compute::RackspaceV2::InvalidServerStateException => e
        exception_occurred = true
        returns(true) {e.desired_state == Fog::Compute::RackspaceV2::Server::VERIFY_RESIZE }
        returns(true) {e.current_state == Fog::Compute::RackspaceV2::Server::ACTIVE }
      end
      exception_occurred
    end

  end

  model_tests(service.servers, options, true) do
    @instance.wait_for { ready? }

    tests('#metadata[\'fog_test\']').returns('true') do
      @instance.metadata['fog_test']
    end

     tests("includes #{@network.label}").returns(true) do
       @instance.addresses.keys.include?(@network.label)
     end

    tests('#create').succeeds do
      pending unless Fog.mocking?
      original_options = Marshal.load(Marshal.dump(options))
      @instance.create(options)
      returns(true) { original_options == options }
    end

    tests('#update').succeeds do
      new_name = "fog_server_update#{Time.now.to_i.to_s}"
      @instance.name = new_name
      @instance.access_ipv4_address= "10.10.0.1"
      @instance.access_ipv6_address= "::1"
      @instance.save
      sleep 60 unless Fog.mocking?
      @instance.reload
      returns("10.10.0.1") { @instance.access_ipv4_address }
      returns("::1") { @instance.access_ipv6_address }
      returns(new_name) { @instance.name }
    end

    tests('#reboot("SOFT")').succeeds do
      @instance.reboot('SOFT')
      returns('REBOOT') { @instance.state }
    end

    @instance.wait_for { ready? }
    tests('#reboot("HARD")').succeeds do
      @instance.reboot('HARD')
      returns('HARD_REBOOT') { @instance.state }
    end

    sleep 30 unless Fog.mocking?
    @instance.wait_for { ready? }
    sleep 60  unless Fog.mocking?
    tests('#rebuild').succeeds do
      @instance.rebuild rackspace_test_image_id(service)
      returns('REBUILD') { @instance.state }
    end

    sleep 30  unless Fog.mocking?
    @instance.wait_for { ready? }
    sleep 60  unless Fog.mocking?
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end

    sleep 30  unless Fog.mocking?
    @instance.wait_for { ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR']) }
    sleep 60  unless Fog.mocking?
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end

    sleep 30 unless Fog.mocking?
    @instance.wait_for { ready? }
    sleep 60 unless Fog.mocking?
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for { ready?('VERIFY_RESIZE') }
    sleep 60  unless Fog.mocking?
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end

    @instance.wait_for { ready? }
    tests('#rescue').succeeds do
      @instance.rescue
    end

    @instance.wait_for { ready?('RESCUE') }
    tests('#unrescue').succeeds do
      @instance.unrescue
    end

    @instance.wait_for  { ready? }
    tests('#change_admin_password').succeeds do
      @instance.change_admin_password('somerandompassword')
      returns('PASSWORD') { @instance.state }
      returns('somerandompassword') { @instance.password }
    end

    @instance.wait_for { ready? }
    @test_image = nil
    begin
      tests('#create_image').succeeds do
        @test_image = @instance.create_image('fog-test-image')
        @test_image.reload
        returns('SAVING') { @test_image.state }
      end
    ensure
      @test_image.destroy unless @test_image.nil? || Fog.mocking?
    end

    tests('attachments') do
      begin
        @volume = cbs_service.volumes.create(:size => 100, :display_name => "fog-#{Time.now.to_i.to_s}")
        @volume.wait_for { ready? }
        tests('#attach_volume').succeeds do
          @instance.attach_volume(@volume)
        end
        tests('#attachments').returns(true) do
          @instance.wait_for do
            !attachments.empty?
          end
          @instance.attachments.any? {|a| a.volume_id == @volume.id }
        end
      ensure
        @volume.wait_for { !attachments.empty? }
        @instance.attachments.each {|a| a.detach }
        @volume.wait_for { ready? && attachments.empty? }
        @volume.destroy if @volume
      end
    end

    @instance.wait_for { ready? }
  end

  tests('#setup') do
    ATTRIBUTES = {
      :name => "foo",
      :image_id => 42,
      :flavor_id => 42
    }

    create_server = lambda { |attributes|
      service = Fog::Compute::RackspaceV2.new
      attributes.merge!(:service => service)

      Fog::SSH::Mock.data.clear

      server = Fog::Compute::RackspaceV2::Server.new(attributes)
      server.save(attributes)

      @address = 123

      server.ipv4_address = @address
      server.identity = "bar"
      server.public_key = "baz"

      server.setup

      server
    }

    commands = lambda {
      Fog::SSH::Mock.data[@address].first[:commands]
    }

    test("lock user when requested") do
      create_server.call(ATTRIBUTES.merge(:passwd_lock => true))
      commands.call.one? { |c| c =~ /passwd\s+-l\s+root/ }
    end

    test("provide a password when the passed isn't locked") do
      pwd = create_server.call(
        ATTRIBUTES.merge(:passwd_lock => false)
      ).password

      # shindo expects a boolean not truthyness :-(
      !!pwd
    end

    test("leaves user unlocked by default") do
      create_server.call(ATTRIBUTES)
      commands.call.none? { |c| c =~ /passwd\s+-l\s+root/ }
    end

    test("nils password when password is locked") do
      pwd = create_server.call(ATTRIBUTES.merge(:passwd_lock => true)).password
      pwd.nil?
    end
  end

  #When after testing resize/resize_confirm we get a 409 when we try to resize_revert so I am going to split it into two blocks
  model_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
    tests('#resize').succeeds do
      @instance.resize(4)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for { ready?('VERIFY_RESIZE') }
    sleep 60 unless Fog.mocking?
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end
    @instance.wait_for { ready? }
  end

  wait_for_server_deletion(@instance)
  delete_test_network(@network)
end
