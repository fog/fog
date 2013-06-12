Shindo.tests('Fog::Volume[:openstack] | volume_types', ['openstack']) do
  @volume_type = Fog::Volume[:openstack].volume_types.create(:name => 'test-volume-type',
                                                             :extra_specs => { 'key-spec' => 'value-spec' })
  
  @volume_types = Fog::Volume[:openstack].volume_types

  tests('success') do
    tests('#all').succeeds do
      @volume_types.all
    end

    tests('#get').succeeds do
      @volume_types.get @volume_type.id
    end
  end
     
  @volume_type.destroy if @volume_type
end