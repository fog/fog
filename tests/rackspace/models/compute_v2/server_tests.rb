Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new
  cbs_service = Fog::Rackspace::BlockStorage.new

  flavor_id  = Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id
  image_id   = Fog.credentials[:rackspace_image_id]  || service.images.first.id
  image_id ||= Fog.mocking? ? service.images.first.id : service.images.find {|image| image.name =~ /Ubuntu/}.id # use the first Ubuntu image

  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => flavor_id,
    :image_id => image_id, 
    :metadata => { 'fog_test' => 'true' }
  }

  model_tests(service.servers, options, true) do
    @instance.wait_for(timeout=1500) { ready? }
    
    tests('#metadata[\'fog_test\']').returns('true') do
      @instance.metadata['fog_test']
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
      @instance.rebuild(image_id)
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
