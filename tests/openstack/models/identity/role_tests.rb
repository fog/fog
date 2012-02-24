Shindo.tests("Fog::Identity[:openstack] | role", ['openstack']) do
  @instance = Fog::Identity[:openstack].roles.new({:name => 'Role Name', :user_id => 1, :role_id => 1})

  tests('success') do
    tests('#save').returns(true) do
      @instance.save
    end

    tests('#destroy').returns(true) do
      @instance.destroy
    end
  end
end

