Shindo.tests('Fog::Rackspace::BlockStorage | volume_type_tests', ['rackspace']) do

  pending if Fog.mocking?

  VOLUME_TYPE_FORMAT = {
    'name' => String,
    'extra_specs' => Hash
  }

  LIST_VOLUME_TYPE_FORMAT = {
    'volume_types' => [VOLUME_TYPE_FORMAT.merge({ 'id' => Integer })]
  }

  GET_VOLUME_TYPE_FORMAT = {
    'volume_type' => VOLUME_TYPE_FORMAT.merge({ 'id' => String })
  }

  service = Fog::Rackspace::BlockStorage.new

  tests('success') do
    volume_type_id = 1

    tests("#list_volume_types").formats(LIST_VOLUME_TYPE_FORMAT) do
      service.list_volume_types.body
    end

    tests("#get_volume_type(#{volume_type_id})").formats(GET_VOLUME_TYPE_FORMAT) do
      service.get_volume_type(volume_type_id).body
    end
  end
end
