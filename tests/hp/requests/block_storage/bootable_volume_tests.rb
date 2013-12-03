Shindo.tests("HP::BlockStorage | bootable volume requests", ['hp', 'block_storage', 'volumes']) do

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

  @boot_volume_format = {
    'status'             => String,
    'displayDescription' => Fog::Nullable::String,
    'availabilityZone'   => String,
    'displayName'        => Fog::Nullable::String,
    'attachments'        => [Fog::Nullable::Hash],
    'volumeType'         => Fog::Nullable::String,
    'snapshotId'         => Fog::Nullable::String,
    'source_image_id'    => Fog::Nullable::String,
    'size'               => Integer,
    'id'                 => Integer,
    'createdAt'          => String,
    'metadata'           => Fog::Nullable::Hash
  }

  @volume_attach_format = {
    "volumeId" => Integer,
    "id"       => Integer
  }

  tests('success') do

    @volume_id = nil
    @volume_name = "fogbvolumetests"
    @volume_desc = @volume_name + " desc"
    @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

    tests("#create_volume(#{@volume_name}, #{@volume_desc}, 10, {'imageRef' => '#{@base_image_id}'})").formats(@volume_format) do
      data = HP[:block_storage].create_volume(@volume_name, @volume_desc, 10, {'imageRef' => "#{@base_image_id}"}).body['volume']
      @volume_id = data['id']
      data
    end

    HP[:block_storage].volumes.get(@volume_id).wait_for { ready? }
    tests("#get_bootable_volume_details(#{@volume_id})").formats(@boot_volume_format) do
      HP[:block_storage].get_bootable_volume_details(@volume_id).body['volume']
    end

    tests("#list_bootable_volumes").formats({'volumes' => [@boot_volume_format]}) do
      HP[:block_storage].list_bootable_volumes.body
    end

    HP[:block_storage].volumes.get(@volume_id).wait_for { ready? }
    tests("#delete_volume(#{@volume_id})").succeeds do
      HP[:block_storage].delete_volume(@volume_id)
    end

  end

  tests('failure') do

    tests("#get_bootable_volume_details(0)").raises(Fog::HP::BlockStorage::NotFound) do
      HP[:block_storage].get_bootable_volume_details(0)
    end

    tests("#delete_volume(0)").raises(Fog::HP::BlockStorage::NotFound) do
      HP[:block_storage].delete_volume(0)
    end

  end

end
