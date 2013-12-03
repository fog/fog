Shindo.tests('Fog::Compute[:aws] | vpc requests', ['aws']) do

  @vpcs_format = {
    'vpcSet' => [{
      'vpcId'           => String,
      'state'           => String,
      'cidrBlock'       => String,
      'dhcpOptionsId'   => String,
      'tagSet'          => Hash,
      'instanceTenancy' => Fog::Nullable::String,
    }],
    'requestId' => String
  }

  tests('success') do

    @vpc_id = nil

    tests('#create_vpc').formats(@vpcs_format) do
      data = Fog::Compute[:aws].create_vpc('10.255.254.0/28').body
      @vpc_id = data['vpcSet'].first['vpcId']
      data
    end

    tests('#describe_vpcs').formats(@vpcs_format) do
      Fog::Compute[:aws].describe_vpcs.body
    end


    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsSupport.Value' => true})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsSupport.Value' => true}).body
    end

    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsHostnames.Value' => true})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsHostnames.Value' => true}).body
    end

    tests("#modify_vpc_attribute('#{@vpc_id}')").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id).body
    end

    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsSupport.Value' => true, 'EnableDnsHostnames.Value' => true})").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsSupport.Value' => true, 'EnableDnsHostnames.Value' => true}).body
    end

    tests("#delete_vpc('#{@vpc_id}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_vpc(@vpc_id).body
    end
  end
end
