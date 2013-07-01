Shindo.tests('Fog::Rackspace::BlockStorage | volume_type_tests', ['rackspace']) do
  volume_type_format = {
    'name' => String,
    'extra_specs' => Hash,
    'id' => String
  }

  service = Fog::Rackspace::BlockStorage.new

  tests('success') do
    volume_type_id = service.volume_types.first.id

    tests("#list_volume_types").formats('volume_types' => [volume_type_format]) do
      service.list_volume_types.body
    end

    tests("#get_volume_type(#{volume_type_id})").formats('volume_type' => volume_type_format) do
      service.get_volume_type(volume_type_id).body
    end
  end
end
