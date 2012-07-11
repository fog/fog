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

  @volume_attach_format = {
    "volumeId" => Integer,
    "device" => String
  }

  tests('success') do

    @volume_id = nil
    @volume_name = "fogvolumetests"
    @volume_desc = @volume_name + " desc"
    @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

    #before do
    #  @server = Fog::Compute[:hp].servers.create(:name => 'fogvoltests', :flavor_id => 100, :image_id => @base_image_id)
    #  @server.wait_for { ready? }
    #end

    tests("#create_volume(#{@volume_name}, #{@volume_desc}, 1)").formats(@volume_format) do
      data = Fog::BlockStorage[:hp].create_volume(@volume_name, @volume_desc, 1).body['volume']
      @volume_id = data['id']
      data
    end

    Fog::BlockStorage[:hp].volumes.get(@volume_id).wait_for { ready? }
    tests("#get_volume_details(#{@volume_id})").formats(@volume_format) do
      Fog::BlockStorage[:hp].get_volume_details(@volume_id).body['volume']
    end

    tests('#list_volumes').formats({'volumes' => [@volume_format]}) do
      Fog::BlockStorage[:hp].list_volumes.body
    end

    @server = Fog::Compute[:hp].servers.create(:name => 'fogvoltests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }
    tests("#attach_volume(#{@server.id}, #{@volume_id}, '/dev/sdg')").formats(@volume_attach_format) do
      Fog::BlockStorage[:hp].compute.attach_volume(@server.id, @volume_id, "/dev/sdg").body['volumeAttachment']
    end

    tests("#detach_volume(#{@server.id}, #{@volume_id})").succeeds do
      Fog::BlockStorage[:hp].compute.detach_volume(@server.id, @volume_id)
    end
    @server.destroy

    Fog::BlockStorage[:hp].volumes.get(@volume_id).wait_for { ready? }
    tests("#delete_volume(#{@volume_id})").succeeds do
      Fog::BlockStorage[:hp].delete_volume(@volume_id)
    end

    #after do
    #  @server.destroy
    #end
  end

  tests('failure') do

    tests('#get_volume_details(0)').raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].get_volume_details(0)
    end

    tests("#attach_volume(0, 0, '/dev/sdg')").raises(Fog::Compute::HP::NotFound) do
      Fog::BlockStorage[:hp].compute.attach_volume(0, 0, "/dev/sdg")
    end
    tests("#attach_volume(#{@server.id}, 0, '/dev/sdg')").raises(Fog::BlockStorage::HP::NotFound) do
      pending if Fog.mocking?
      Fog::BlockStorage[:hp].compute.attach_volume(@server.id, 0, "/dev/sdg")
    end

    tests("#detach_volume(0, 0)").raises(Fog::Compute::HP::NotFound) do
      Fog::BlockStorage[:hp].compute.detach_volume(0, 0)
    end
    tests("#detach_volume(#{@server.id}, 0)").raises(Fog::BlockStorage::HP::NotFound) do
      pending if Fog.mocking?
      Fog::BlockStorage[:hp].compute.detach_volume(@server.id, 0)
    end

    tests("#delete_volume(0)").raises(Fog::BlockStorage::HP::NotFound) do
      Fog::BlockStorage[:hp].delete_volume(0)
    end

  end

end
