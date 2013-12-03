Shindo.tests('Fog::Rackspace::BlockStorage | volume_tests', ['rackspace']) do

  volume_format = {
    'id' => String,
    'status' => String,
    'display_name' => Fog::Nullable::String,
    'display_description' => Fog::Nullable::String,
    'size' => Integer,
    'created_at' => String,
    'volume_type' => String,
    'availability_zone' => String,
    'snapshot_id' => Fog::Nullable::String,
    'attachments' => Array,
    'metadata' => Hash
  }

  get_volume_format = {
    'volume' => volume_format
  }

  list_volume_format = {
    'volumes' => [volume_format]
  }

  service = Fog::Rackspace::BlockStorage.new

  tests('success') do
    id = nil
    size = 100

    tests("#create_volume(#{size})").formats(get_volume_format) do
      data = service.create_volume(size).body
      id = data['volume']['id']
      data
    end

    tests("#list_volumes").formats(list_volume_format) do
      service.list_volumes.body
    end

    tests("#get_volume(#{id})").formats(get_volume_format) do
      service.get_volume(id).body
    end

    tests("#delete_volume(#{id})").succeeds do
      service.delete_volume(id)
    end
  end

  tests('failure') do
    tests("#create_volume(-1)").raises(Fog::Rackspace::BlockStorage::BadRequest) do
      service.create_volume(-1)
    end

    tests("#get_volume(-1)").raises(Fog::Rackspace::BlockStorage::NotFound) do
      service.get_volume(-1)
    end
  end
end
