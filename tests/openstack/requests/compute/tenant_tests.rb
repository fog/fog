Shindo.tests('Fog::Compute[:openstack] | tenant requests', ['openstack']) do

  @tenant_format = {
    'id'    => String,
    'name'  => String,
    'enabled'    => Fog::Boolean,
    'description' => Fog::Nullable::String
  }

  tests('success') do
    tests('#list_tenants').formats({'tenants_links' => Array, 'tenants' => [@tenant_format]}) do
      Fog::Compute[:openstack].list_tenants.body
    end

    tests('#set_tenant("admin")').succeeds do
      Fog::Compute[:openstack].set_tenant("admin")
    end
  end
end
