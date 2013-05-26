Shindo.tests('Fog::Volume[:openstack] | volume', ['openstack']) do

  tests('success') do
    tests('#create').succeeds do
      @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                       :display_description => 'Test Volume',
                                                       :size => 1, 
                                                       :metadata => { 'key-volume' => 'value-volume' })
      !@volume.id.nil?
    end

    @volume.wait_for { status == 'available' } if @volume
    
    tests('#update').succeeds do
      @volume.display_name = 'new-test-volume'
      @volume.display_description = 'New Test Volume'
      @volume.metadata['new-key-volume'] = 'new-value-volume'
      @volume.update
    end

    tests('#destroy').succeeds do      
      @volume.destroy == true
    end
  end
                 
  Fog.wait_for { @volume.reload.nil? } if @volume
end