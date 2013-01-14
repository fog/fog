service = Fog::Compute::RackspaceV2.new
cbs_service = Fog::Rackspace::BlockStorage.new
flavor_id  = Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id
image_id   = Fog.credentials[:rackspace_image_id]  || service.images.first.id

Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do

  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => flavor_id,
    :image_id => image_id
  }

<<<<<<< HEAD
  model_tests(service.servers, options, false) do
    @instance.wait_for(timeout=1500) { ready? }
    
    tests('#update').succeeds do
      @instance.name = "fog_server_update"
      @instance.access_ipv4_address= "10.10.0.1"
      @instance.access_ipv6_address= "0:0:0:0:0:0:0:1"
      @instance.save
      sleep 60
      @instance.reload
      returns("10.10.0.1") { @instance.access_ipv4_address }
      returns("0:0:0:0:0:0:0:1") { @instance.access_ipv6_address }
      returns("fog_server_update") { @instance.name }
    end
    
=======
  model_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#reboot("SOFT")').succeeds do
      @instance.reboot('SOFT')
      returns('REBOOT') { @instance.state }
    end

<<<<<<< HEAD
    @instance.wait_for(timeout=1500) { ready? }
=======
    @instance.wait_for(timeout=1500)  { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#reboot("HARD")').succeeds do
      @instance.reboot('HARD')
      returns('HARD_REBOOT') { @instance.state }
    end

<<<<<<< HEAD
    sleep 30
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60
=======
    @instance.wait_for(timeout=1500)  { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#rebuild').succeeds do
      @instance.rebuild('5cebb13a-f783-4f8c-8058-c4182c724ccd')
      returns('REBUILD') { @instance.state }
    end

<<<<<<< HEAD
    sleep 30
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60    
=======
    @instance.wait_for(timeout=1500)  { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end

<<<<<<< HEAD
    sleep 30
    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR']) }
    sleep 60    
=======
    @instance.wait_for(timeout=1500)  { state == 'VERIFY_RESIZE' }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end

<<<<<<< HEAD
    sleep 30
    @instance.wait_for(timeout=1500) { ready? }
    sleep 60                
=======
    @instance.wait_for(timeout=1500)  { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end

<<<<<<< HEAD
    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE') }
    sleep 60
=======
    @instance.wait_for(timeout=1500)  { state == 'VERIFY_RESIZE' }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end

<<<<<<< HEAD
    @instance.wait_for(timeout=1500) { ready? }
=======
    @instance.wait_for(timeout=1500)  { ready? }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
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
<<<<<<< HEAD
  
    @instance.wait_for(timeout=1500) { ready?('VERIFY_RESIZE') }
    sleep 60
=======

    @instance.wait_for(timeout=1500) { state == 'VERIFY_RESIZE' }
>>>>>>> 840aa5230674387f5393dca23ac5416105271215
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end
    @instance.wait_for(timeout=1500) { ready? }
  end
end
