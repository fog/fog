Shindo.tests('Fog::Volume[:openstack] | backup requests', ['openstack']) do

  @backup_format = {
    'id'                => String,
    'name'              => Fog::Nullable::String,
    'description'       => Fog::Nullable::String,
    'status'            => Fog::Nullable::String,
    'size'              => Fog::Nullable::Integer,
    'container'         => Fog::Nullable::String,
    'volume_id'         => Fog::Nullable::String,
    'object_count'      => Fog::Nullable::Integer,
    'availability_zone' => Fog::Nullable::String,
    'created_at'        => Fog::Nullable::String,
    'fail_reason'       => Fog::Nullable::String,
    'links'             => Array,
  }

  tests('success') do
    @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                     :display_description => 'Test Volume',
                                                     :size => 1)
    @volume.wait_for { status == 'available' } if @volume
    @backup = nil
    
    tests('#create_backup').formats({'backup' => @backup_format}) do    
      attributes = {:name => 'test-backup',
                    :description => 'Test Backup'}
      data = Fog::Volume[:openstack].create_backup(@volume.id, attributes).body
      @backup = Fog::Volume[:openstack].backups.get(data['backup']['id'])
      data
    end
    
    @backup.wait_for { status == 'available' } if @backup

    tests('#list_backups').formats({'backups' => [@backup_format]}) do
      Fog::Volume[:openstack].list_backups.body
    end

    tests('#get_backup_details').formats({'backup' => @backup_format}) do
      Fog::Volume[:openstack].get_backup_details(@backup.id).body
    end

    tests('#restore_backup').succeeds do
      Fog::Volume[:openstack].restore_backup(@backup.id, @volume.id)
    end
    
    @backup.wait_for { status == 'available' } if @backup
    
    tests('#delete_backup').succeeds do
      Fog::Volume[:openstack].delete_backup(@backup.id)
    end

    Fog.wait_for { @backup.reload.nil? } if @backup
    @volume.destroy if @volume
    Fog.wait_for { @volume.reload.nil? } if @volume
  end

  tests('failure') do
    tests('#get_backupt_details').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].get_backup_details(0)
    end

    tests('#restore_backup').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].restore_backup(0, 'volume-uuid')
    end
    
    tests('#delete_backup').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].delete_backup(0)
    end
  end

end