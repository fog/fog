Shindo.tests('Fog::BlockStorage[:hp] | snapshot requests', ['hp', 'block_storage', 'snapshots']) do

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

    @volume = Fog::BlockStorage[:hp].volumes.create(:name => 'fogvolforsnap', :size => 1)
    @volume.wait_for { ready? }

    tests("#create_snapshot(#{@snapshot_name}, #{@snapshot_desc}, #{@volume.id})").formats(@snapshot_format) do
      data = Fog::BlockStorage[:hp].create_snapshot(@snapshot_name, @snapshot_desc, @volume.id).body['snapshot']
      @snapshot_id = data['id']
      data
    end

    tests("#get_snapshot_details(#{@snapshot_id})").formats(@snapshot_format) do
      Fog::BlockStorage[:hp].get_snapshot_details(@snapshot_id).body['snapshot']
    end

    tests('#list_snapshots').formats({'snapshots' => [@snapshot_format]}) do
      Fog::BlockStorage[:hp].list_snapshots.body
    end

    tests("#delete_snapshot(#{@snapshot_id})").succeeds do
      Fog::BlockStorage[:hp].delete_snapshot(@snapshot_id)
    end

  end

  tests('failure') do

    tests('#get_snapshot_details(0)').raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].get_snapshot_details(0)
    end

    tests("#delete_snapshot(0)").raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].delete_snapshot(0)
    end

  end

  @volume.destroy

end
