Shindo.tests("Fog::Identity[:openstack] | roles", ['openstack']) do
  @user   = Fog::Identity[:openstack].users.all.first
  @tenant = Fog::Identity[:openstack].tenants.all.first
  @roles  = Fog::Identity[:openstack].roles(:user => @user, :tenant => @tenant)

  tests('success') do
    tests('#all').succeeds do
      @roles.all
    end

    @role = @roles.all.first
    tests('#add_user_role(@user.id, @tenant.id, @role.id)').returns(true) do
      @roles.add_user_role(@user.id, @tenant.id, @role.id)
    end

    tests('#remove_user_role(@user.id, @tenant.id, @role.id)').returns(true) do
      @roles.remove_user_role(@user.id, @tenant.id, @role.id)
    end
  end
end
