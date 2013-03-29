Shindo.tests('HP::Network | networking subnet model', ['hp', 'networking', 'subnet']) do

  @network = HP[:network].networks.create(:name => 'my_network')

  attributes = {:name => 'fogsubnet', :network_id => @network.id, :cidr => '11.11.11.11/11', :ip_version => 4}
  model_tests(HP[:network].subnets, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'my_subnet', :network_id => @network.id, :cidr => '12.12.12.12/12', :ip_version => 4}
      @subnet = HP[:network].subnets.create(attributes)
      @subnet.wait_for { ready? } unless Fog.mocking?
      !@subnet.id.nil?
    end

    tests('#save').succeeds do
      @subnet.name = 'my_subnet_upd'
      @subnet.save
    end

    tests('#destroy').succeeds do
      @subnet.destroy
    end

  end

  @network.destroy

end
