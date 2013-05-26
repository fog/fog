Shindo.tests('Fog::Volume[:openstack] | snapshot requests', ['openstack']) do

  @snapshot_format = {
    'id'                  => String,
    'display_name'        => String,
    'display_description' => String,
    'status'              => String,
    'size'                => Integer,
    'volume_id'           => String,
    'created_at'          => String,
    'metadata'            => Hash,
    'progress'            => Fog::Nullable::String,
    'project_id'          => Fog::Nullable::String,
  }
  
  tests('success') do
    @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                     :display_description => 'Test Volume',
                                                     :size => 1)
    @volume.wait_for { status == 'available' } if @volume
    @snapshot = nil

    tests('#create_snapshot').formats({'snapshot' => @snapshot_format}) do
      display_name = 'test-snapshot'
      display_description = 'Test Snapshot'
      attributes = {:metadata => { 'key-snapshot' => 'value-snapshot' }}
      data = Fog::Volume[:openstack].create_snapshot(@volume.id, display_name, display_description, true, attributes).body
      @snapshot = Fog::Volume[:openstack].snapshots.get(data['snapshot']['id'])
      data
    end

    @snapshot.wait_for { status == 'available' } if @snapshot
    
    tests('#list_snapshots').formats({'snapshots' => [@snapshot_format]}) do
      Fog::Volume[:openstack].list_snapshots.body
    end

    tests('#get_snapshot_details').formats({'snapshot' => @snapshot_format}) do
      Fog::Volume[:openstack].get_snapshot_details(@snapshot.id).body
    end
    
    tests('#update_snapshot').formats({'snapshot' => @snapshot_format}) do
      attributes = {:display_name => 'new-test-snapshot', 
                    :display_description => 'New Test Snapshot',
                    :metadata => { 'new-key-snapshot' => 'new-value-snapshot' }}
      Fog::Volume[:openstack].update_snapshot(@snapshot.id, attributes).body
    end

    tests('#delete_snapshot').succeeds do
      Fog::Volume[:openstack].delete_snapshot(@snapshot.id)
    end
    
    Fog.wait_for { @snapshot.reload.nil? } if @snapshot
    @volume.destroy if @volume
    Fog.wait_for { @volume.reload.nil? } if @volume
  end
  
  tests('failure') do
    tests('#get_snapshot_details').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].get_snapshot_details(0)
    end

    tests('#update_snapshot').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].update_snapshot(0, {})
    end

    tests('#delete_snapshot').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].delete_snapshot(0)
    end
  end

end