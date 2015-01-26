Shindo.tests('HP::Network | networking ports collection', ['hp', 'networking', 'port']) do

  @network = HP[:network].networks.create(:name => 'my_network')

  attributes = {:name => 'my_port', :network_id => @network.id}
  collection_tests(HP[:network].ports, attributes, true)

  tests('success') do

    attributes = {:name => 'fogport', :network_id => @network.id}
    @port = HP[:network].ports.create(attributes)

    tests('#all(filter)').succeeds do
      HP[:network].ports.all({:name => 'fogport'})
    end

    @port.destroy
  end

  @network.destroy
end
