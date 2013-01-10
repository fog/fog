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
    
    tests('#update').succeeds do
      @instance.name = "fog_server_update"
      @instance.access_ipv4_address= "10.10.0.1"
      @instance.access_ipv6_address= "0:0:0:0:0:0:0:1"
      @instance.save
      @instance.reload
      returns("10.10.0.1") { @instance.access_ipv4_address }
      returns("0:0:0:0:0:0:0:1") { @instance.access_ipv6_address }
      returns("fog_server_update") { @instance.name }
    end
    
    tests('#reboot("SOFT")').succeeds do
      @instance.reboot('SOFT')
      returns('REBOOT') { @instance.state }
    end

    @instance.wait_for(timeout=1500) { ready? }
    tests('#reboot("HARD")').succeeds do
      @instance.reboot('HARD')
      returns('HARD_REBOOT') { @instance.state }
    end

    @instance.wait_for(timeout=1500) { ready? }    
    tests('#rebuild').succeeds do
      @instance.rebuild('5cebb13a-f783-4f8c-8058-c4182c724ccd')
      returns('REBUILD') { @instance.state }
    end

    @instance.wait_for(timeout=1500) { ready? }
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for(timeout=1500) do 
      raise "ERROR: Server is in ACTIVE state and it should be in VERIFY_RESIZE" if state == 'ACTIVE'
      state == 'VERIFY_RESIZE'
    end
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end

    @instance.wait_for(timeout=1500) { ready? }
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

    @instance.wait_for(timeout=1500) { state == 'VERIFY_RESIZE' }
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end

    @instance.wait_for(timeout=1500) { ready? }
    tests('#change_admin_password').succeeds do
      @instance.change_admin_password('somerandompassword')
      returns('PASSWORD') { @instance.state }
      returns('somerandompassword') { @instance.password }
    end

    @instance.wait_for(timeout=1500) { ready? }
  end
  
  # When after testing resize/resize_confirm we get a 409 when we try to resize_revert so I am going to split it into two blocks
  model_tests(service.servers, options, false) do
    @instance.wait_for(timeout=1500) { ready? }
    tests('#resize').succeeds do
      @instance.resize(4)
      returns('RESIZE') { @instance.state }
    end
  
    @instance.wait_for(timeout=1500) { state == 'VERIFY_RESIZE' }
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end
    @instance.wait_for { ready? }    
  end  
end
