Shindo.tests('Fog::Identity[:openstack] | tenant requests', ['openstack']) do

  @tenant_format = {
    'id'   => String,
    'name' => String,
    'enabled'     => Fog::Boolean,
    'description' => String
  }

  @role_format = {
    'id'   => String,
    'name' => String
  }

  tests('success') do
    tests('#list_tenants').formats({'tenants' => [@tenant_format]}) do
      Fog::Identity[:openstack].list_tenants.body
    end

    tests('#list_roles_for_user_on_tenant(0,1)').
      formats({'roles' => [@role_format]}) do

      pending unless Fog.mocking?
      Fog::Identity[:openstack].list_roles_for_user_on_tenant(0,1).body
    end

    tests('#get_tenant').formats({'tenant' => @tenant_format}) do
      pending unless Fog.mocking?
      Fog::Identity[:openstack].get_tenant(0).body
    end
  end
end
