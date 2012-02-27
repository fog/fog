Shindo.tests('Fog::Identity[:openstack] | user requests', ['openstack']) do

  @user_format = {
    'id'   => String,
    'name' => String,
    'enabled'  => Fog::Boolean,
    'email'    => String,
    'tenantId' => Fog::Nullable::String
  }

  tests('success') do
    tests('#create_user("Onamae", "spoof", "user@email.com", "t3n4nt1d", true)').formats(@user_format, false) do
      @user = Fog::Identity[:openstack].create_user("Onamae", "spoof", "morph@example.com", "m0rPh1d").body['user']
    end

    tests('#list_users').formats({'users' => [@user_format]}) do
      Fog::Identity[:openstack].list_users.body
    end

    tests("#update_user(#{@user['id']}, :name => 'fogupdateduser')").succeeds do
      Fog::Identity[:openstack].update_user(@user['id'], :name => 'fogupdateduser', :email => 'fog@test.com')
    end

    tests("#delete_user(#{@user['id']})").succeeds do
      Fog::Identity[:openstack].delete_user(@user['id'])
    end

  end
end
