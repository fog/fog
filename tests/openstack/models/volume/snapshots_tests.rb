Shindo.tests('Fog::Volume[:openstack] | snapshots', ['openstack']) do
  @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                   :display_description => 'Test Volume',
                                                   :size => 1)
  @volume.wait_for { status == 'available' } if @volume
  
  @snapshot = Fog::Volume[:openstack].snapshots.create(:display_name => 'test-snapshot',
                                                       :display_description => 'Test Snapshot',
                                                       :volume_id => @volume.id,
                                                       :metadata => { 'key-snapshot' => 'value-snapshot' })
  @snapshot.wait_for { status == 'available' } if @snapshot

  @snapshots = Fog::Volume[:openstack].snapshots

  tests('success') do
    tests('#all').succeeds do
      @snapshots.all
    end

    tests('#get').succeeds do
      @snapshots.get @snapshot.id
    end
  end

  @snapshot.destroy if @snapshot
  Fog.wait_for { @snapshot.reload.nil? } if @snapshot     
    
  @volume.destroy if @volume
  Fog.wait_for { @volume.reload.nil? } if @volume
end