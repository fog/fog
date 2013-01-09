Shindo.tests('Fog::Compute::RackspaceV2 | server', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  cbs_service = Fog::Rackspace::BlockStorage.new
  timestamp = Time.now.to_i.to_s
  
  options = {
    :name => "fog_server_#{timestamp}",
    :flavor_id => 2,
    :image_id => '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001'
  }

   model_tests(service.servers, options, false) do
    @instance.wait_for(timeout=1500)  { ready? }
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
    tests('#rebuild').succeeds do
      @instance.rebuild('5cebb13a-f783-4f8c-8058-c4182c724ccd')
      returns('REBUILD') { @instance.state }
    end
    
    @instance.wait_for(timeout=1500)  { ready? }
    tests('#resize').succeeds do
      @instance.resize(3)
      returns('RESIZE') { @instance.state }
    end
    
    @instance.wait_for(timeout=1500)  { state == 'VERIFY_RESIZE' }
    tests('#confirm_resize').succeeds do
      @instance.confirm_resize
    end
    
    @instance.wait_for(timeout=1500)  { ready? }
    tests('#resize').succeeds do
      @instance.resize(2)
      returns('RESIZE') { @instance.state }
    end
    
    @instance.wait_for(timeout=1500)  { state == 'VERIFY_RESIZE' }
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
        @volume = cbs_service.volumes.create(:size => 100, :display_name => "fog-#{timestamp}")
        @volume.wait_for(timeout=1500) { ready? }
        tests('#attach_volume') do
          @instance.attach_volume(@volume, "/dev/xvdb")
          @instance.wait_for(timeout=1500)  do
            !attachments.empty?
          end
          returns(true) { @instance.attachments.any? {|a| a.volume_id == @volume.id } } 
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
  model_tests(service.servers, options, false) do
    @instance.wait_for(timeout=1500)  { ready? }
    tests('#resize').succeeds do
      @instance.resize(4)
      returns('RESIZE') { @instance.state }
    end
  
    @instance.wait_for(timeout=1500)  { state == 'VERIFY_RESIZE' }
    tests('#revert_resize').succeeds do
      @instance.revert_resize
    end
    @instance.wait_for(timeout=1500)  { ready? }    
  end  
end
