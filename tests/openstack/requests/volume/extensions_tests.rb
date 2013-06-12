Shindo.tests('Fog::Volume[:openstack] | extensions requests', ['openstack']) do

  @extensions_format = {
    'updated'     => String,
    'name'        => String,
    'links'       => Array,
    'namespace'   => String,
    'alias'       => String,
    'description' => String,
  }

  tests('success') do
    tests('#list_extensions').formats({'extensions' => [@extensions_format]}) do
      Fog::Volume[:openstack].list_extensions.body
    end
  end

end