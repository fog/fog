Shindo.tests('Fog::Identity[:openstack] | user requests', ['openstack']) do

  @user_format = {
    'id'   => String,
    'name' => String,
    'enabled'  => Fog::Boolean,
    'email'    => String,
    'tenantId' => Fog::Nullable::String
  }

  tests('success') do
    tests('#list_users').formats({'users' => [@user_format]}) do
      Fog::Identity[:openstack].list_users.body
    end
  end
end
