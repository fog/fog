Shindo.tests('Fog::Compute[:aws] | subnet requests', ['aws']) do

  @subnets_format = {
    'subnetSet' => [{
      'subnetId'                 => String,
      'state'                    => String,
      'vpcId'                    => String,
      'cidrBlock'                => String,
      'availableIpAddressCount'  => String,
      'availabilityZone'         => String,
      'tagSet'                   => Hash,
    }],
    'requestId' => String
  }

  tests('success') do
    @vpc=Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
    @vpc_id = @vpc.id
    @subnet_id = nil

    tests('#create_subnet').formats(@subnets_format) do
      data = Fog::Compute[:aws].create_subnet(@vpc_id, '10.0.10.16/28').body
      @subnet_id = data['subnetSet'].first['subnetId']
      data
    end

    tests('#describe_subnets').formats(@subnets_format) do
      Fog::Compute[:aws].describe_subnets.body
    end

    tests("#delete_subnet('#{@subnet_id}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_subnet(@subnet_id).body
    end
    @vpc.destroy
  end
end
