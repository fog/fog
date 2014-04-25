Shindo.tests('Fog::Compute[:aws] | subnet requests', ['aws']) do

  @subnet_format = {
    'subnetId'                 => String,
    'state'                    => String,
    'vpcId'                    => String,
    'cidrBlock'                => String,
    'availableIpAddressCount'  => String,
    'availabilityZone'         => String,
    'tagSet'                   => Hash,
  }

  @single_subnet_format = {
    'subnet'    => @subnet_format,
    'requestId' => String,
  }

  @subnets_format = {
    'subnetSet' => [@subnet_format],
    'requestId' => String
  }

  @vpc_network = '10.0.10.0/24'
  @vpc=Fog::Compute[:aws].vpcs.create('cidr_block' => @vpc_network)
  @vpc_id = @vpc.id

  tests('success') do
    @subnet_id = nil
    @subnet_network = '10.0.10.16/28'

    tests("#create_subnet('#{@vpc_id}', '#{@subnet_network}')").formats(@single_subnet_format) do
      data = Fog::Compute[:aws].create_subnet(@vpc_id, @subnet_network).body
      @subnet_id = data['subnet']['subnetId']
      data
    end

    @vpc2=Fog::Compute[:aws].vpcs.create('cidr_block' => @vpc_network)
    @vpc2_id = @vpc2.id

    # Create a second subnet in a second VPC with the same netblock
    tests("#create_subnet('#{@vpc2_id}', '#{@subnet_network}')").formats(@single_subnet_format) do
      data = Fog::Compute[:aws].create_subnet(@vpc2_id, @subnet_network).body
      @subnet2_id = data['subnet']['subnetId']
      data
    end

    Fog::Compute[:aws].delete_subnet(@subnet2_id)

    tests('#describe_subnets').formats(@subnets_format) do
      Fog::Compute[:aws].describe_subnets.body
    end

    tests("#delete_subnet('#{@subnet_id}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_subnet(@subnet_id).body
    end
  end

  tests('failure') do
    tests("#create_subnet('vpc-00000000', '10.0.10.0/16')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].create_subnet('vpc-00000000', '10.0.10.0/16')
    end

    tests("#create_subnet('#{@vpc_id}', '10.0.9.16/28')").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].create_subnet(@vpc_id, '10.0.9.16/28')
    end

    # Attempt to create two subnets with conflicting CIDRs in the same VPC
    tests("#create_subnet('#{@vpc_id}', '10.0.10.0/24'); " \
      "#create_subnet('#{@vpc_id}', '10.0.10.64/26'); ").raises(::Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].create_subnet(@vpc_id, '10.0.10.0/24')
      Fog::Compute[:aws].create_subnet(@vpc_id, '10.0.10.64/26')
    end
  end

  @vpc.destroy
end
