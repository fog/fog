Shindo.tests("Fog::Network[:openstack] | routers", ['openstack']) do
  @router = Fog::Network[:openstack].routers.create(
    :name => 'router_name',
    :admin_state_up => true
  )
  @routers = Fog::Network[:openstack].routers

  tests('success') do

    tests('#all').succeeds do
      @routers.all
    end

    tests('#get').succeeds do
      @routers.get @router.id
    end

  end

  @router.destroy
end
