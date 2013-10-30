Shindo.tests('HP::Network | networking router model', ['hp', 'networking', 'router']) do

  # needed to test router_interface calls
  @network = HP[:network].networks.create(:name => 'fognetwork')
  @subnet = HP[:network].subnets.create({:name => 'fogsubnet', :network_id => @network.id, :cidr => '13.13.13.13/13', :ip_version => 4})
  @port = HP[:network].ports.create({:name => 'fogport', :network_id => @network.id})

  attributes = {:name => 'fogrouter', :admin_state_up => true}
  model_tests(HP[:network].routers, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'my_router', :admin_state_up => true}
      @router = HP[:network].routers.create(attributes)
      @router.wait_for { ready? } unless Fog.mocking?
      !@router.id.nil?
    end

    tests('#save').succeeds do
      @router.name = 'my_router_upd'
      @router.save
    end

    tests("#add_interface(#{@subnet.id}, nil) - with subnet").succeeds do
      @router.add_interface(@subnet.id)
    end
    #tests("#remove_interface(#{@subnet.id}, nil) - with subnet").succeeds do
    #  @router.remove_interface(@subnet.id)
    #end
    tests("#add_interface(nil, #{@port.id}) - with port").succeeds do
      @router.add_interface(nil, @port.id)
    end
    ## deletes the port as well
    tests("#remove_interface(nil, #{@port.id}) - with port").succeeds do
      @router.remove_interface(nil, @port.id)
    end

    tests("#add_interface(#{@subnet.id}, #{@port.id}) - with both").succeeds do
      @router.add_interface(@subnet.id, @port.id) == false
    end
    tests("#add_interface(#{@subnet.id}, #{@port.id}) - with both").succeeds do
      @router.remove_interface(@subnet.id, @port.id) == false
    end

    tests('#destroy').succeeds do
      @router.destroy
    end

  end

  @subnet.destroy
  @network.destroy

end
