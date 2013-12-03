Shindo.tests("Fog::Identity[:openstack] | user", ['openstack']) do
  tenant_id = Fog::Identity[:openstack].list_tenants.body['tenants'].first['id']
  @instance = Fog::Identity[:openstack].users.new({
    :name      => 'User Name',
    :email     => 'test@fog.com',
    :tenant_id => tenant_id,
    :password  => 'spoof',
    :enabled   => true
  })

  tests('success') do
    tests('#save').returns(true) do
      @instance.save
    end

    tests('#roles').succeeds do
      @instance.roles
    end

    tests('#update').returns(true) do
      @instance.update({:name => 'updatename', :email => 'new@email.com'})
    end

    tests('#update_password').returns(true) do
      @instance.update_password('swordfish')
    end

    tests('#update_tenant').returns(true) do
      @instance.update_tenant(tenant_id)
    end

    tests('#update_enabled').returns(true) do
      @instance.update_enabled(true)
    end

    tests('#destroy').returns(true) do
      @instance.destroy
    end
  end

  tests('failure') do
    tests('#save').raises(Fog::Errors::Error) do
      @instance.save
    end
  end
end
