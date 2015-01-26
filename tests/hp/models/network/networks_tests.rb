Shindo.tests('HP::Network | networking networks collection', ['hp', 'networking', 'network']) do

  attributes = {:name => 'my_network', :admin_state_up => true, :shared => false}
  collection_tests(HP[:network].networks, attributes, true)

  tests('success') do

    tests('#all(filter)').succeeds do
      networks = HP[:network].networks.all({'router:external'=>true})
      networks.first.router_external == true
    end

  end

end
