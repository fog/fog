Shindo.tests('Fog::Volume[:openstack] | volume_type', ['openstack']) do

  tests('success') do
    tests('#create').succeeds do
      @volume_type = Fog::Volume[:openstack].volume_types.create(:name => 'test-volume-type',
                                                                 :extra_specs => { 'key-spec' => 'value-spec' })
      !@volume_type.id.nil?
    end

    tests('#set_extra_spec').succeeds do
      @volume_type.set_extra_spec('new-key-spec', 'new-value-spec') == true
    end

    tests('#unset_extra_spec').succeeds do
      @volume_type.unset_extra_spec('new-key-spec') == true
    end
    
    tests('#destroy').succeeds do
      @volume_type.destroy == true
    end
  end
  
  tests('failure') do
    before do
      @volume_type = Fog::Volume[:openstack].volume_types.create(:name => 'test-volume-type',
                                                                 :extra_specs => { 'key-spec' => 'value-spec' })
    end
    
    after do
      @volume_type.destroy if @volume_type
    end
    
    tests('#update').raises(Fog::Errors::Error, 'Resaving an existing object may create a duplicate') do
      @volume_type.save
    end    
  end

end