Shindo.tests('Fog::BlockStorage[:hp] | volume requests', ['hp', 'block_storage']) do

  @volume_format = {
    'status'             => String,
    'displayDescription' => Fog::Nullable::String,
    'availabilityZone'   => String,
    'displayName'        => Fog::Nullable::String,
    'attachments'        => [Fog::Nullable::Hash],
    'volumeType'         => Fog::Nullable::String,
    'snapshotId'         => Fog::Nullable::String,
    'size'               => Integer,
    'id'                 => Integer,
    'createdAt'          => String,
    'metadata'           => Fog::Nullable::Hash
  }

  tests('success') do

    @volume_id = nil
    @volume_name = "fogvolumetests"
    @volume_desc = @volume_name + " desc"

    tests("#create_volume(#{@volume_name}, #{@volume_desc}, 1)").formats(@volume_format) do
      data = Fog::BlockStorage[:hp].create_volume(@volume_name, @volume_desc, 1).body['volume']
      @volume_id = data['id']
      data
    end

    #Fog::BlockStorage[:hp].volumes.get(@volume_id).wait_for { ready? }
    #
    tests("#get_volume_details(#{@volume_id})").formats(@volume_format) do
      Fog::BlockStorage[:hp].get_volume_details(@volume_id).body['volume']
    end

    tests('#list_volumes').formats({'volumes' => [@volume_format]}) do
      Fog::BlockStorage[:hp].list_volumes.body
    end

    #Fog::BlockStorage[:hp].volumes.get(@volume_id).wait_for { ready? }
    #
    tests("#delete_volume(#{@volume_id})").succeeds do
      Fog::BlockStorage[:hp].delete_volume(@volume_id)
    end

    # Add attach_volume and detach_volume tests

  end

  tests('failure') do

    tests('#delete_volume(0)').raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].delete_volume(0)
    end

    tests('#get_volume_details(0)').raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].get_volume_details(0)
    end

    # Add attach_volume and detach_volume tests
  end

end
