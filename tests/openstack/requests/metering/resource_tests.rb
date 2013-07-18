Shindo.tests('Fog::Metering[:openstack] | resource requests', ['openstack']) do

  @resource_format = {
    'resource_id' => String,
    'project_id'  => String,
    'user_id'     => String,
    'metadata'    => Hash,
  }

  tests('success') do
    tests('#list_resource').formats([@resource_format]) do
      Fog::Metering[:openstack].list_resources.body
    end

    tests('#get_resource').formats(@resource_format) do
      Fog::Metering[:openstack].get_resource('test').body
    end
  end
end
