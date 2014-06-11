Shindo.tests('HP::Network | networking floating ips collection', ['hp', 'networking', 'floatingip']) do

  @ext_network = HP[:network].networks.all({'router:external'=>true}).first

  attributes = {:floating_network_id => @ext_network.id}
  collection_tests(HP[:network].floating_ips, attributes, true)

end
