Shindo.tests('Fog::Volume[:openstack] | volume_types requests', ['openstack']) do

  @volume_type_format = {
    'id'          => String,
    'name'        => String,
    'extra_specs' => Hash,
  }

  tests('success') do
    tests('#create_volume_type').formats({'volume_type' => @volume_type_format}) do
      name = 'test-volume-type'
      attributes = {:extra_specs => { 'key-spec' => 'value-spec' }}
      Fog::Volume[:openstack].create_volume_type(name, attributes).body
    end
    
    tests('#list_volume_types').formats({'volume_types' => [@volume_type_format]}) do
      Fog::Volume[:openstack].list_volume_types.body
    end

    tests('#get_volume_type_details').formats({'volume_type' => @volume_type_format}) do
      volume_type_id = Fog::Volume[:openstack].volume_types.all.first.id
      Fog::Volume[:openstack].get_volume_type(volume_type_id).body
    end

    tests('#set_volume_type_extra_spec').succeeds do
      volume_type_id = Fog::Volume[:openstack].volume_types.all.first.id
      Fog::Volume[:openstack].set_volume_type_extra_spec(volume_type_id, 'key-spec', 'value-spec')
    end

    tests('#unset_volume_type_extra_spec').succeeds do
      volume_type_id = Fog::Volume[:openstack].volume_types.all.first.id
      Fog::Volume[:openstack].unset_volume_type_extra_spec(volume_type_id, 'key-spec')
    end
    
    tests('#delete_volume_type').succeeds do
      volume_type_id = Fog::Volume[:openstack].volume_types.all.first.id
      Fog::Volume[:openstack].delete_volume_type(volume_type_id)
    end
  end

  tests('failure') do
    tests('#get_volume_type_details').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].get_volume_type(0)
    end

    tests('#set_volume_type_extra_spec').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].set_volume_type_extra_spec(0, 'key-spec', 'value-spec')
    end

    tests('#unset_volume_type_extra_spec').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].unset_volume_type_extra_spec(0, 'key-spec')
    end
    
    tests('#delete_volume_type').raises(Fog::Volume::OpenStack::NotFound) do
      Fog::Volume[:openstack].delete_volume_type(0)
    end
  end

end