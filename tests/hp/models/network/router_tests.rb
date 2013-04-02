Shindo.tests('HP::Network | networking router model', ['hp', 'networking', 'router']) do

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

    tests('#destroy').succeeds do
      @router.destroy
    end

  end

end
