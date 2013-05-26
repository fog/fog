Shindo.tests('Fog::Volume[:openstack] | snapshot', ['openstack']) do
  @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                   :display_description => 'Test Volume',
                                                   :size => 1)
  @volume.wait_for { status == 'available' } if @volume
  
  tests('success') do
    tests('#create').succeeds do
      @snapshot = Fog::Volume[:openstack].snapshots.create(:display_name => 'test-snapshot',
                                                           :display_description => 'Test Snapshot',
                                                           :volume_id => @volume.id,
                                                           :metadata => { 'key-snapshot' => 'value-snapshot' })
      !@snapshot.id.nil?
    end
    
    @snapshot.wait_for { status == 'available' } if @snapshot
    
    tests('#update').succeeds do
      @snapshot.display_name = 'new-test-snapshot'
      @snapshot.display_description = 'New Test Snapshot'
      @snapshot.metadata['new-key-snapshot'] = 'new-value-snapshot'
      @snapshot.update
    end

    tests('#destroy').succeeds do
      @snapshot.destroy == true
    end
  end

  Fog.wait_for { @snapshot.reload.nil? } if @snapshot  

  @volume.destroy if @volume
  Fog.wait_for { @volume.reload.nil? } if @volume
end