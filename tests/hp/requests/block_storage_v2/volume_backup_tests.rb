Shindo.tests("Fog::HP::BlockStorageV2 | volume backup requests", ['hp', 'v2', 'block_storage', 'volume_backup']) do

  @backup_details_format = {
    'id'                  => String,
    'status'              => String,
    'name'                => Fog::Nullable::String,
    'description'         => Fog::Nullable::String,
    'container'           => String,
    'availability_zone'   => String,
    'created_at'          => String,
    'volume_id'           => String,
    'size'                => Integer,
    'links'               => [Fog::Nullable::Hash],
    'fail_reason'         => Fog::Nullable::String,
    'object_count'        => Integer
  }

  @backup_format = {
    'id'     => String,
    'name'   => Fog::Nullable::String,
    'links'  => [Fog::Nullable::Hash]
  }

  @restore_format = {
    'backup_id' => String,
    'volume_id' => String
  }

  tests('success') do

    @backup_id = nil
    @backup_name = 'fogvolbackup2tests'
    @backup_desc = @backup_name + ' desc'

    @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvol2forbackup', :size => 1)
    @volume.wait_for { ready? }

    @target_volume = HP[:block_storage_v2].volumes.create(:name => 'fogtargetvolume', :size => 2)
    @target_volume.wait_for { ready? }

    tests("#create_volume_backup(#{@volume.id}, {'name' => #{@backup_name}, 'description' => #{@backup_desc}, 'container' => 'my_backups')").formats(@backup_format) do
      data = HP[:block_storage_v2].create_volume_backup(@volume.id, {'name' => @backup_name, 'description' => @backup_desc, 'container' => 'my_backups'}).body['backup']
      @backup_id = data['id']
      data
    end

    tests("#get_volume_backup_details(#{@backup_id})").formats(@backup_details_format) do
      HP[:block_storage_v2].get_volume_backup_details(@backup_id).body['backup']
    end

    tests('#list_volume_backups').formats({'backups' => [@backup_format]}) do
      HP[:block_storage_v2].list_volume_backups.body
    end

    tests('#list_volume_backups_detail').formats({'backups' => [@backup_details_format]}) do
      HP[:block_storage_v2].list_volume_backups_detail.body
    end

    # restore into new volume
    tests("#restore_volume_backup(#{@backup_id}").formats(@restore_format) do
      data = HP[:block_storage_v2].restore_volume_backup(@backup_id).body['restore']
      restored_volume_id = data['volume_id']
      restored_volume = HP[:block_storage_v2].get_volume_details(restored_volume_id).body['volume']
      test ('should create a new volume with backup restored') do
        restored_volume['display_name'] == @volume.name
        restored_volume['display_description'] == @volume.description
        restored_volume['availability_zone'] == @volume.availability_zone
        restored_volume['size'] == @volume.size
      end
      data
    end

    ## restore into existing volume
    tests("#restore_volume_backup(#{@backup_id}, {'volume_id' => #{@target_volume.id}}").formats(@restore_format) do
      data = HP[:block_storage_v2].restore_volume_backup(@backup_id, {'volume_id' => @target_volume.id}).body['restore']
      restored_volume_id = data['volume_id']
      restored_volume = HP[:block_storage_v2].get_volume_details(restored_volume_id).body['volume']
      test ('should overwrite the existing volume with backup restored') do
        restored_volume['id'] == @target_volume.id
        restored_volume['display_name'] == @volume.name
        restored_volume['display_description'] == @volume.description
        restored_volume['availability_zone'] == @volume.availability_zone
        restored_volume['size'] == @volume.size
      end
      data
    end
    #
    tests("#delete_volume_backup(#{@backup_id})").succeeds do
      HP[:block_storage_v2].delete_volume_backup(@backup_id)
    end

  end

  tests('failure') do

    tests('#get_volume_backup_details("0")').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].get_volume_backup_details('0')
    end

    tests('#restore_volume_backup("0")').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].restore_volume_backup('0')
    end

    tests("#restore_volume_backup(#{@backup_id}, '0')").raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].restore_volume_backup(@backup_id, '0')
    end

    tests('#delete_volume_backup("0")').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].delete_volume_backup('0')
    end

  end

  @target_volume.destroy
  @volume.destroy

end
