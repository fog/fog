Shindo.tests('HP::Network | networking subnets collection', ['hp', 'networking', 'subnet']) do

  @network = HP[:network].networks.create(:name => 'my_network')

  attributes = {:name => 'my_subnet', :network_id => @network.id, :cidr => '11.11.11.11/11', :ip_version => 4}
  collection_tests(HP[:network].subnets, attributes, true)

  tests('success') do

    attributes = {:name => 'fogsubnet', :network_id => @network.id, :cidr => '12.12.12.12/12', :ip_version => 4}
    @subnet = HP[:network].subnets.create(attributes)

    tests('#all(filter)').succeeds do
      subnets = HP[:network].subnets.all({:cidr => '12.12.12.12/12'})
      subnets.first.cidr == '12.12.12.12/12'
    end

    @subnet.destroy
  end

  @network.destroy
end
