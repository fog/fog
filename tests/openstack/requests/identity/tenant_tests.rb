Shindo.tests('Fog::Identity[:openstack] | tenant requests', ['openstack']) do

  @tenant_format = {
    'id'   => String,
    'name' => String,
    'enabled'     => Fog::Nullable::Boolean,
    'description' => Fog::Nullable::String,
    'extra' => Fog::Nullable::Hash
  }

  @role_format = {
    'id'   => String,
    'name' => String
  }

  tests('success') do
    tests('#list_tenants').formats({'tenants' => [@tenant_format], 'tenants_links' => []}) do
      Fog::Identity[:openstack].list_tenants.body
    end

    tests('#list_roles_for_user_on_tenant(0,1)').
      formats({'roles' => [@role_format]}) do

      openstack = Fog::Identity[:openstack]
      openstack.list_roles_for_user_on_tenant(
        openstack.tenants.first, openstack.users.first).body
    end

    tests('#create_tenant').formats({'tenant' => @tenant_format}) do
      @instance = Fog::Identity[:openstack].create_tenant('name' => 'test').body
    end

    tests('#get_tenant').formats({'tenant' => @tenant_format}) do
      Fog::Identity[:openstack].get_tenant(@instance['tenant']['id']).body
    end

    tests('#update_tenant check format').formats({'tenant' => @tenant_format}) do
      @instance = Fog::Identity[:openstack].update_tenant(
        @instance['tenant']['id'], 'name' => 'test2').body
    end

    tests('#update_tenant update name').succeeds do
      @instance = Fog::Identity[:openstack].update_tenant(
        @instance['tenant']['id'], 'name' => 'test3').body
      @instance['tenant']['name'] == 'test3'
    end

    tests('#delete_tenant').succeeds do
      Fog::Identity[:openstack].delete_tenant(@instance['tenant']['id'])
    end

  end
end
