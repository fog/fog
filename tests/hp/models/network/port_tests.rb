Shindo.tests('HP::Network | networking port model', ['hp', 'networking', 'port']) do

  @network = HP[:network].networks.create(:name => 'my_network')

  attributes = {:name => 'fogport', :network_id => @network.id}
  model_tests(HP[:network].ports, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'my_port', :network_id => @network.id}
      @port = HP[:network].ports.create(attributes)
      @port.wait_for { ready? } unless Fog.mocking?
      !@port.id.nil?
    end

    tests('#save').succeeds do
      @port.name = 'my_port_upd'
      @port.save
    end

    tests('#destroy').succeeds do
      @port.destroy
    end

  end

  @network.destroy

end
