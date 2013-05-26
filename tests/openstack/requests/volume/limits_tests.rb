Shindo.tests('Fog::Volume[:openstack] | limits requests', ['openstack']) do

  @limits_format = {
    'rate'     => Array,
    'absolute' => Hash,    
  }

  tests('success') do
    tests('#list_limits').formats({'limits' => @limits_format}) do
      Fog::Volume[:openstack].list_limits.body
    end
  end

end