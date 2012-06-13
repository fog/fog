Shindo.tests("Fog::Compute[:openstack] | tenants", ['openstack']) do
  @instance = Fog::Identity[:openstack].tenants.create(:name => 'test')

  tests('success') do
    tests('#find_by_id').succeeds do
      tenant = Fog::Identity[:openstack].tenants.find_by_id(@instance.id)
      tenant.id == @instance.id
    end

    tests('#destroy').succeeds do
      Fog::Identity[:openstack].tenants.destroy(@instance.id)
    end
  end

  tests('fails') do
    pending if Fog.mocking?

    tests('#find_by_id').raises(Fog::Identity::OpenStack::NotFound) do
      Fog::Identity[:openstack].tenants.find_by_id('fake')
    end

    tests('#destroy').raises(Fog::Identity::OpenStack::NotFound) do
      Fog::Identity[:openstack].tenants.destroy('fake')
    end
  end
end
