Shindo.tests('Fog::Volume[:openstack] | volume_type requests', ['openstack']) do

  @volume_type_format = {
    'name'        => String,
    'extra_specs' => Hash,
    'id'          => String
  }

  tests('success') do
    tests('#create_volume_type').formats(@volume_type_format) do
      @volume_type = Fog::Volume[:openstack].create_volume_type(:name => 'test_volume_type').body['volume_type']
      @volume_type
    end

    tests('#update_volume_type').formats(@volume_type_format) do
      Fog::Volume[:openstack].update_volume_type(@volume_type['id'],
                                                 :name => 'test_volume_type_1').body['volume_type']
    end

    tests('#get_volume_type').formats(@volume_type_format) do
      Fog::Volume[:openstack].get_volume_type_details(@volume_type['id']).body['volume_type']
    end

    tests('#list_volume_type').formats([@volume_type_format]) do
      Fog::Volume[:openstack].list_volume_types.body['volume_types']
    end

    succeeds do
      Fog::Volume[:openstack].delete_volume_type(@volume_type['id'])
    end
  end
end
