Shindo.tests("Fog::Compute[:openstack] | tenant", ['openstack']) do
  @instance = Fog::Identity[:openstack].tenants.first

  tests('success') do
    tests('#roles_for(0)').succeeds do
      @instance.roles_for(0)
    end
  end
end
