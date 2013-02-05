Shindo.tests('Fog::Identity[:openstack] | tenant requests', ['openstack']) do

  @tenant_format = {
    'id'   => String,
    'name' => String,
    'enabled'     => Fog::Nullable::Boolean,
    'description' => Fog::Nullable::String
  }

  @role_format = {
    'id'   => String,
    'name' => String
  }

  @tenant_name = Fog::Mock.random_hex(64)
  @tenant_name_update = Fog::Mock.random_hex(64)
  @tenant_name_update2 = Fog::Mock.random_hex(64)

  tests('success') do
    tests('#list_tenants').formats({'tenants' => [@tenant_format], 'tenants_links' => []}) do
      Fog::Identity[:openstack].list_tenants.body
    end

    tests('#list_roles_for_user_on_tenant(0,1)').
      formats({'roles' => [@role_format]}) do

      openstack = Fog::Identity[:openstack]
      openstack.list_roles_for_user_on_tenant(
        openstack.current_tenant['id'], OpenStack::Identity.get_user_id).body
    end

    tests('#create_tenant').formats({'tenant' => @tenant_format}) do
      @tenant = Fog::Identity[:openstack].create_tenant('name' => @tenant_name).body
    end

    tests('#get_tenant').formats({'tenant' => @tenant_format}) do
      Fog::Identity[:openstack].get_tenant(@tenant['tenant']['id']).body
    end

    tests('#update_tenant check format').formats({'tenant' => @tenant_format}) do
      @tenant = Fog::Identity[:openstack].update_tenant(
        @tenant['tenant']['id'], 'name' => @tenant_name_update).body
    end

    tests('#update_tenant update name').succeeds do
      @tenant = Fog::Identity[:openstack].update_tenant(
        @tenant['tenant']['id'], 'name' => @tenant_name_update2).body
      @tenant['tenant']['name'] == @tenant_name_update2
    end

    tests('#delete_tenant').succeeds do
      Fog::Identity[:openstack].delete_tenant(@tenant['tenant']['id'])
    end

  end
end
