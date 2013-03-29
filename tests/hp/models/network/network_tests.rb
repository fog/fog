Shindo.tests('HP::Network | networking network model', ['hp', 'networking', 'network']) do

  model_tests(HP[:network].networks, {:name => 'fognetwork'}, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'my_network', :admin_state_up => true, :shared => false}
      @network = HP[:network].networks.create(attributes)
      @network.wait_for { ready? } unless Fog.mocking?
      !@network.id.nil?
    end

    tests('#save').succeeds do
      @network.name = 'my_network_upd'
      @network.save
    end

    tests('#destroy').succeeds do
      @network.destroy
    end

  end

end
