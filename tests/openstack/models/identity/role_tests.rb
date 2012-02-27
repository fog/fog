Shindo.tests("Fog::Identity[:openstack] | role", ['openstack']) do
  @instance = Fog::Identity[:openstack].roles.new({:name => 'Role Name', :user_id => 1, :role_id => 1})
  @user     = Fog::Identity[:openstack].users.all.first
  @tenant   = Fog::Identity[:openstack].tenants.all.first

  tests('success') do
    tests('#save').returns(true) do
      @instance.save
    end

    tests('#add_to_user(@user.id, @tenant.id)').returns(true) do
      @instance.add_to_user(@user.id, @tenant.id)
    end

    tests('#remove_to_user(@user.id, @tenant.id)').returns(true) do
      @instance.remove_to_user(@user.id, @tenant.id)
    end

    tests('#destroy').returns(true) do
      @instance.destroy
    end
  end
end

