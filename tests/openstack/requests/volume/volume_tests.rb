Shindo.tests('Fog::Volume[:openstack] | volume requests', ['openstack']) do

  @volume_format = {
    'id'                  => String,
    'display_name'        => String,
    'display_description' => String,
    'status'              => String,
    'size'                => Integer,
    'volume_type'         => Fog::Nullable::String,
    'snapshot_id'         => Fog::Nullable::String,
    'availability_zone'   => Fog::Nullable::String,
    'created_at'          => String,
    'attachments'         => Array,
    'metadata'            => Hash,
    'source_volid'        => Fog::Nullable::String,
    'bootable'            => Fog::Nullable::String,
    'host'                => Fog::Nullable::String,
    'tenant_id'           => Fog::Nullable::String,
  }

  tests('success') do
    @volume = nil
    
    tests('#create_volume').formats({'volume' => @volume_format}) do
      display_name = 'test-volume'
      display_description = 'Test Volume'
      size = 1
      attributes = {:metadata => { 'key-volume' => 'value-volume' }}
      data = Fog::Volume[:openstack].create_volume(display_name, display_description, size, attributes).body
      @volume = Fog::Volume[:openstack].volumes.get(data['volume']['id'])
      data
    end

    @volume.wait_for { status == 'available' } if @volume
    
    tests('#list_volumes').formats({'volumes' => [@volume_format]}) do
      Fog::Volume[:openstack].list_volumes.body
    end

    tests('#get_volume_details').formats({'volume' => @volume_format}) do
      Fog::Volume[:openstack].get_volume_details(@volume.id).body
    end
    
    tests('#update_volume').formats({'volume' => @volume_format}) do
      attributes = {:display_name => 'new-test-volume', 
                    :display_description => 'New Test Volume',
                    :metadata => { 'new-key-volume' => 'new-value-volume' }}
      Fog::Volume[:openstack].update_volume(@volume.id, attributes).body
    end

    tests('#delete_volume').succeeds do
      Fog::Volume[:openstack].delete_volume(@volume.id)
    end
    
    Fog.wait_for { @volume.reload.nil? } if @volume
  end

  tests('failure') do
    tests('#get_volume_details').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].get_volume_details(0)
    end

    tests('#update_volume').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].update_volume(0, {})
    end

    tests('#delete_volume').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].delete_volume(0)
    end
  end

end