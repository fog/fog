Shindo.tests('HP::BlockStorage | snapshot requests', ['hp', 'block_storage', 'snapshots']) do

  @snapshot_format = {
    'status'             => String,
    'displayDescription' => Fog::Nullable::String,
    'displayName'        => Fog::Nullable::String,
    'volumeId'           => Integer,
    'size'               => Integer,
    'id'                 => Integer,
    'createdAt'          => String
  }

  tests('success') do

    @snapshot_id = nil
    @snapshot_name = "fogsnapshottests"
    @snapshot_desc = @snapshot_name + " desc"

    @volume = HP[:block_storage].volumes.create(:name => 'fogvolforsnap', :size => 1)
    @volume.wait_for { ready? }

    tests("#create_snapshot(#{@snapshot_name}, #{@snapshot_desc}, #{@volume.id})").formats(@snapshot_format) do
      data = HP[:block_storage].create_snapshot(@snapshot_name, @snapshot_desc, @volume.id).body['snapshot']
      @snapshot_id = data['id']
      data
    end

    tests("#get_snapshot_details(#{@snapshot_id})").formats(@snapshot_format) do
      HP[:block_storage].get_snapshot_details(@snapshot_id).body['snapshot']
    end

    tests('#list_snapshots').formats({'snapshots' => [@snapshot_format]}) do
      HP[:block_storage].list_snapshots.body
    end

    tests("#delete_snapshot(#{@snapshot_id})").succeeds do
      HP[:block_storage].delete_snapshot(@snapshot_id)
    end

  end

  tests('failure') do

    tests('#get_snapshot_details(0)').raises(Fog::HP::BlockStorage::NotFound) do
      HP[:block_storage].get_snapshot_details(0)
    end

    tests("#delete_snapshot(0)").raises(Fog::HP::BlockStorage::NotFound) do
      HP[:block_storage].delete_snapshot(0)
    end

  end

  @volume.destroy

end
