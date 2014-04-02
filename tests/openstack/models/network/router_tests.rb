Shindo.tests("Fog::Network[:openstack] | router", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].routers.create(
        :name => 'router_name',
        :admin_state_up => true
      )
      !@instance.id.nil?
    end

    tests('#update') do
      test('router name') do
        @instance.name = 'new_name'
        @instance.update
        @instance.name == 'new_name'
      end
      # Needs code from issue #1598
      #test 'external_gateway_info' do
      #  net = Fog::Network[:openstack].networks.create(
      #    :name => 'net_name',
      #    :shared => false,
      #    :admin_state_up => true,
      #    :tenant_id => 'tenant_id',
      #    :router_external => true,
      #  )
      #  @instance.external_gateway_info = net
      #  @instance.update
      #end
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
