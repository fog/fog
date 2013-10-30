Shindo.tests('HP::BlockStorageV2 | snapshot requests', ['hp', 'v2', 'block_storage', 'snapshots']) do

  @snapshot_format = {
    'status'              => String,
    'display_description' => Fog::Nullable::String,
    'display_name'        => Fog::Nullable::String,
    'volume_id'           => String,
    'size'                => Integer,
    'id'                  => String,
    'created_at'          => String,
    'metadata'            => Fog::Nullable::Hash
  }

  tests('success') do

    @snapshot_id = nil
    @snapshot_name = 'fogsnapshot2tests'
    @snapshot_desc = @snapshot_name + ' desc'

    @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvol2forsnap', :size => 1)
    @volume.wait_for { ready? }

    tests("#create_snapshot(#{@volume.id}, {'display_name' => #{@snapshot_name}, 'display_description' => #{@snapshot_desc} })").formats(@snapshot_format) do
      data = HP[:block_storage_v2].create_snapshot(@volume.id, {'display_name' => @snapshot_name, 'display_description' => @snapshot_desc} ).body['snapshot']
      @snapshot_id = data['id']
      data
    end

    tests("#get_snapshot_details(#{@snapshot_id})").formats(@snapshot_format) do
      HP[:block_storage_v2].get_snapshot_details(@snapshot_id).body['snapshot']
    end

    tests("#update_snapshot(#{@snapshot_id}, 'display_name' => '#{@snapshot_name} Updated')").formats(@snapshot_format) do
      HP[:block_storage_v2].update_snapshot(@snapshot_id, 'display_name' => "#{@snapshot_name} Updated").body['snapshot']
    end

    tests('#list_snapshots').formats({'snapshots' => [@snapshot_format]}) do
      HP[:block_storage_v2].list_snapshots.body
    end

    tests('#list_snapshots_detail').formats({'snapshots' => [@snapshot_format]}) do
      HP[:block_storage_v2].list_snapshots_detail.body
    end

    tests("#delete_snapshot(#{@snapshot_id})").succeeds do
      HP[:block_storage_v2].delete_snapshot(@snapshot_id)
    end

  end

  tests('failure') do

    tests('#get_snapshot_details(0)').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].get_snapshot_details(0)
    end

    tests('#update_snapshot(0)').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].update_snapshot(0)
    end

    tests('#delete_snapshot(0)').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].delete_snapshot(0)
    end

  end

  @volume.destroy

end
