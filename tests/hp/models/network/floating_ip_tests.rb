Shindo.tests('HP::Network | networking floating ip model', ['hp', 'networking', 'floatingip']) do

  @ext_network = HP[:network].networks.all({'router:external'=>true}).first

  attributes = {:floating_network_id => @ext_network.id}
  model_tests(HP[:network].floating_ips, attributes, true)

  tests('success') do

    @network = HP[:network].networks.create(:name => 'my_network')
    attributes = {:name => 'port1', :network_id => @network.id}
    @port = HP[:network].ports.create(attributes)

    tests('#create').succeeds do
      attributes = {:floating_network_id => @ext_network.id}
      @fip = HP[:network].floating_ips.create(attributes)
      @fip.wait_for { ready? } unless Fog.mocking?
      !@fip.id.nil?
    end

    tests("#associate_port(#{@port.id})").succeeds do
      @fip.associate_port(@port.id)
    end

    # this will delete the port as well
    tests('#disassociate_port').succeeds do
      @fip.disassociate_port
    end

    tests('#destroy').succeeds do
      @fip.destroy
    end

    @network.destroy
  end

end
