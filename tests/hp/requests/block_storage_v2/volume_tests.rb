Shindo.tests("Fog::HP::BlockStorageV2 | volume requests", ['hp', 'v2', 'block_storage', 'volumes']) do

  compute_service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @volume_format = {
    'id'                  => String,
    'display_name'        => Fog::Nullable::String,
    'display_description' => Fog::Nullable::String,
    'size'                => Integer,
    'status'              => String,
    'volume_type'         => Fog::Nullable::String,
    'snapshot_id'         => Fog::Nullable::String,
    'source_volid'        => Fog::Nullable::String,
    'bootable'            => Fog::Boolean,
    'created_at'          => String,
    'availability_zone'   => String,
    'attachments'         => [Fog::Nullable::Hash],
    'metadata'            => Fog::Nullable::Hash
  }

  @volume_attach_format = {
    'device'    => String,
    'serverId'  => String,
    'volumeId'  => String,
    'id'        => String
  }

  tests('success') do

    @volume_id = nil
    @volume_name = 'fogvolume2tests'
    @volume_desc = @volume_name + ' desc'
    @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

    @server = compute_service.servers.create(:name => 'fogvoltests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }

    tests("#create_volume('display_name' => #{@volume_name}, 'display_description' => #{@volume_desc}, 'size' => 1)").formats(@volume_format) do
      data = HP[:block_storage_v2].create_volume('display_name' => @volume_name, 'display_description' => @volume_desc, 'size' => 1).body['volume']
      @volume_id = data['id']
      data
    end

    tests("#get_volume_details(#{@volume_id})").formats(@volume_format) do
      HP[:block_storage_v2].get_volume_details(@volume_id).body['volume']
    end

    tests("#update_volume(#{@volume_id}, 'display_name' => #{@volume_name}+' Upd'").formats(@volume_format) do
      data = HP[:block_storage_v2].update_volume(@volume_id, 'display_name' => @volume_name).body['volume']
      @volume_id = data['id']
      data
    end

    tests('#list_volumes').formats({'volumes' => [@volume_format]}) do
      HP[:block_storage_v2].list_volumes.body
    end

    tests('#list_volumes_detail').formats({'volumes' => [@volume_format]}) do
      HP[:block_storage_v2].list_volumes_detail.body
    end

    tests("#attach_volume(#{@server.id}, #{@volume_id}, '/dev/sdg')").formats(@volume_attach_format) do
      compute_service.attach_volume(@server.id, @volume_id, "/dev/sdg").body['volumeAttachment']
    end

    tests("#detach_volume(#{@server.id}, #{@volume_id})").succeeds do
      compute_service.detach_volume(@server.id, @volume_id)
    end

    tests("#delete_volume(#{@volume_id})").succeeds do
      HP[:block_storage_v2].delete_volume(@volume_id)
    end

  end

  tests('failure') do

    tests('#get_volume_details(0)').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].get_volume_details(0)
    end

    tests("#attach_volume(0, 0, '/dev/sdg')").raises(Fog::Compute::HPV2::NotFound) do
      compute_service.attach_volume(0, 0, "/dev/sdg")
    end
    tests("#attach_volume(#{@server.id}, 0, '/dev/sdg')").raises(Fog::HP::BlockStorageV2::NotFound) do
      pending if Fog.mocking?
      compute_service.attach_volume(@server.id, 0, "/dev/sdg")
    end

    tests('#detach_volume(0, 0)').raises(Fog::Compute::HPV2::NotFound) do
      compute_service.detach_volume(0, 0)
    end
    tests("#detach_volume(#{@server.id}, 0)").raises(Fog::HP::BlockStorageV2::NotFound) do
      pending if Fog.mocking?
      compute_service.detach_volume(@server.id, 0)
    end

    tests('#delete_volume(0)').raises(Fog::HP::BlockStorageV2::NotFound) do
      HP[:block_storage_v2].delete_volume(0)
    end

  end

  @server.destroy

end
