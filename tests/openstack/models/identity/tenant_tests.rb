Shindo.tests("Fog::Identity[:openstack] | tenant", ['openstack']) do
  tests('success') do
    tests('#roles_for(0)').succeeds do
      instance = Fog::Identity[:openstack].tenants.first
      instance.roles_for(0)
    end

    tests('#users').succeeds do
      instance = Fog::Identity[:openstack].tenants.first

      instance.users.count != Fog::Identity[:openstack].users.count
    end
  end

  tests('CRUD') do
    tests('#create').succeeds do
      @instance = Fog::Identity[:openstack].tenants.create(:name => 'test')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.update(:name => 'test2')
      @instance.name == 'test2'
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end
  end
end
