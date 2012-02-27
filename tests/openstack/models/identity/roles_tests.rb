Shindo.tests("Fog::Identity[:openstack] | roles", ['openstack']) do
  @user     = Fog::Identity[:openstack].users.all.first
  @tenant   = Fog::Identity[:openstack].tenants.all.first
  @roles  = Fog::Identity[:openstack].roles(:user => @user, :tenant => @tenant)

  tests('success') do
    tests('#all').succeeds do
      @roles.all
    end

    tests('#get').succeeds do
      @roles.get @roles.first.id
    end
  end
end
