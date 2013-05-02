Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new
  cbs_service = Fog::Rackspace::BlockStorage.new

  tests('setup test network').succeeds do
    @network = service.networks.create :label => "fog_test_net_#{Time.now.to_i.to_s}", :cidr => '192.168.1.1/24'
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
    @instance.wait_for(timeout=1500) { ready? }
    
    tests('#metadata[\'fog_test\']').returns('true') do
      @instance.metadata['fog_test']
    end
    
     tests("includes #{@network.label}").returns(true) do
       @instance.addresses.keys.include?(@network.label)
     end

    tests('#update').succeeds do
      @instance.name = "fog_server_update"
      @instance.access_ipv4_address= "10.10.0.1"
      @instance.access_ipv6_address= "0:0:0:0:0:0:0:1"
      @instance.save
      sleep 60 unless Fog.mocking?
      @instance.reload
      returns("10.10.0.1") { @instance.access_ipv4_address }
      returns("0:0:0:0:0:0:0:1") { @instance.access_ipv6_address }
      returns("fog_server_update") { @instance.name }
    end
    
    tests('#reboot("SOFT")').succeeds do
      @instance.reboot('SOFT')
      returns('REBOOT') { @instance.state }
    end

    @instance.wait_for(timeout=1500)  { ready? }
    tests('#reboot("HARD")').succeeds do
      @instance.reboot('HARD')
      returns('HARD_REBOOT') { @instance.state }
    end
    
    @instance.wait_for(timeout=1500)  { ready? }
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

    sleep 30 unless Fog.mocking?
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60  unless Fog.mocking?
    tests('#rebuild').succeeds do
      @instance.rebuild rackspace_test_image_id(service)
      returns('REBUILD') { @instance.state }
    end

    sleep 30  unless Fog.mocking?
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60  unless Fog.mocking?
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end

    sleep 30  unless Fog.mocking?
    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR']) }
    sleep 60  unless Fog.mocking?
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end

    sleep 30 unless Fog.mocking?
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60 unless Fog.mocking?
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE') }
    sleep 60  unless Fog.mocking?
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end

    @instance.wait_for(timeout=1500)  { ready? }
    tests('#rescue').succeeds do
      @instance.rescue
    end

    @instance.wait_for(timeout=1500) { ready?('RESCUE') }
    tests('#unrescue').succeeds do
      @instance.unrescue
    end

    @instance.wait_for(timeout=1500)  { ready? }
    tests('#change_admin_password').succeeds do
      @instance.change_admin_password('somerandompassword')
      returns('PASSWORD') { @instance.state }
      returns('somerandompassword') { @instance.password }
    end

    tests('attachments') do
      begin
        @volume = cbs_service.volumes.create(:size => 100, :display_name => "fog-#{Time.now.to_i.to_s}")
        @volume.wait_for(timeout=1500) { ready? }
        tests('#attach_volume').succeeds do
          @instance.attach_volume(@volume)
        end
        tests('#attachments').returns(true) do
          @instance.wait_for(timeout=1500)  do
            !attachments.empty?
          end
          @instance.attachments.any? {|a| a.volume_id == @volume.id }
        end
      ensure
        @volume.wait_for(timeout=1500) { !attachments.empty? }
        @instance.attachments.each {|a| a.detach }
        @volume.wait_for(timeout=1500) { ready? && attachments.empty? }        
        @volume.destroy if @volume
      end
    end

    @instance.wait_for(timeout=1500)  { ready? }
   end

   wait_for_server_deletion(@instance)

   tests("delete network #{@network.label}").succeeds do
     @network.destroy if @network
   end

  #When after testing resize/resize_confirm we get a 409 when we try to resize_revert so I am going to split it into two blocks
  model_tests(service.servers, options, true) do
    @instance.wait_for(timeout=1500) { ready? }
    tests('#resize').succeeds do
      @instance.resize(4)
      returns('RESIZE') { @instance.state }
    end
  
    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE') }
    sleep 60 unless Fog.mocking?
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end
    @instance.wait_for(timeout=1500) { ready? }
  end
end
