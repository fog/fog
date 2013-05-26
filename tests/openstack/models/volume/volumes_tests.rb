Shindo.tests('Fog::Volume[:openstack] | volumes', ['openstack']) do
  @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                   :display_description => 'Test Volume',
                                                   :size => 1, 
                                                   :metadata => { 'key-volume' => 'value-volume' })
  @volume.wait_for { status == 'available' } if @volume
  
  @volumes = Fog::Volume[:openstack].volumes        

  tests('success') do
    tests('#all').succeeds do
      @volumes.all
    end

    tests('#get').succeeds do
      @volumes.get @volume.id
    end
  end
    
  @volume.destroy if @volume
  Fog.wait_for { @volume.reload.nil? } if @volume
end