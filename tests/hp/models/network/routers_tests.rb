Shindo.tests('HP::Network | networking routers collection', ['hp', 'networking', 'router']) do

  attributes = {:name => 'my_router', :admin_state_up => true}
  collection_tests(HP[:network].routers, attributes, true)

  tests('success') do

    attributes = {:name => 'fogrouter', :admin_state_up => true}
    @router = HP[:network].routers.create(attributes)

    tests('#all(filter)').succeeds do
      routers = HP[:network].routers.all({:name => 'fogrouter'})
      routers.first.name == 'fogrouter'
    end

    @router.destroy
  end

end
