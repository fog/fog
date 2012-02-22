Shindo.tests("Fog::Compute[:openstack] | user", ['openstack']) do
  @instance = Fog::Identity[:openstack].users.first

  tests('success') do
    tests('#roles').succeeds do
      @instance.roles
    end
  end
end
