Shindo.tests('Fog::Compute[:aws] | internet_gateway requests', ['aws']) do

  tests('success') do

    @vpc=Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
    @vpc_id = @vpc.id

    @subnet=Fog::Compute[:aws].subnets.create('vpc_id' => @vpc_id, 'cidr_block' => '10.0.10.0/24')
    @subnet_id = @subnet.subnet_id

    @network_interface = Fog::Compute[:aws].network_interfaces.new(:subnet_id => @subnet_id)
    @network_interface.save
    @network_interface_id =  @network_interface.network_interface_id

    @ip_address = Fog::AWS::Mock.ip_address

    tests("#assign_private_ip_addresses('#{@network_interface_id}', '#{@ip_address}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].assign_private_ip_addresses(@network_interface_id, @ip_address).body
    end

    tests("#assign_private_ip_addresses('#{@network_interface_id}', nil, 4)").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].assign_private_ip_addresses(@network_interface_id, nil, 4).body
    end

    tests("#assign_private_ip_addresses('#{@network_interface_id}', @ip_address, nil, true)").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].assign_private_ip_addresses(@network_interface_id, @ip_address, nil, true).body
    end

    @network_interface.destroy
    @subnet.destroy
    @vpc.destroy
  end

  tests('failure') do
    @vpc=Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
    @vpc_id = @vpc.id

    @subnet=Fog::Compute[:aws].subnets.create('vpc_id' => @vpc_id, 'cidr_block' => '10.0.10.0/24')
    @subnet_id = @subnet.subnet_id

    @network_interface = Fog::Compute[:aws].network_interfaces.new(:subnet_id => @subnet_id)
    @network_interface.save
    @network_interface_id =  @network_interface.network_interface_id

    @ip_address = Fog::AWS::Mock.ip_address

    tests("#assign_private_ip_addresses('#{@network_interface_id}', @ip_address, nil, true)").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].assign_private_ip_addresses(@network_interface_id, @ip_address, 4).body
    end
    
  end
end