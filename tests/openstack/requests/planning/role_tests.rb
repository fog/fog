Shindo.tests('Fog::Openstack[:planning] | Planning role requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @role_format = {
    'description' => Fog::Nullable::String,
    'name'        => Fog::Nullable::String,
    'uuid'        => String,
    'version'     => Integer,
  }

  tests('success') do
    tests('#list_roles').data_matches_schema([@role_format]) do
      Fog::Openstack[:planning].list_roles.body
    end
  end
end
