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

    [ 'enableDnsSupport', 'enableDnsHostnames'].each do |attrib|
      tests("#describe_vpc_attribute('#{@vpc_id}', #{attrib})").returns(@vpc_id) do
        Fog::Compute[:aws].describe_vpc_attribute(@vpc_id, attrib).body['vpcId']
      end
    end

    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsSupport.Value' => false})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsSupport.Value' => false}).body
    end
    tests("#describe_vpc_attribute(#{@vpc_id}, 'enableDnsSupport')").returns(false) do
      Fog::Compute[:aws].describe_vpc_attribute(@vpc_id, 'enableDnsSupport').body["enableDnsSupport"]
    end
    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsSupport.Value' => true})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsSupport.Value' => true}).body
    end
    tests("#describe_vpc_attribute(#{@vpc_id}, 'enableDnsSupport')").returns(true) do
      Fog::Compute[:aws].describe_vpc_attribute(@vpc_id, 'enableDnsSupport').body["enableDnsSupport"]
    end

    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsHostnames.Value' => true})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsHostnames.Value' => true}).body
    end
    tests("#describe_vpc_attribute(#{@vpc_id}, 'enableDnsHostnames')").returns(true) do
      Fog::Compute[:aws].describe_vpc_attribute(@vpc_id, 'enableDnsHostnames').body["enableDnsHostnames"]
    end
    tests("#modify_vpc_attribute('#{@vpc_id}', {'EnableDnsHostnames.Value' => false})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].modify_vpc_attribute(@vpc_id, {'EnableDnsHostnames.Value' => false}).body
    end
    tests("#describe_vpc_attribute(#{@vpc_id}, 'enableDnsHostnames')").returns(false) do
      Fog::Compute[:aws].describe_vpc_attribute(@vpc_id, 'enableDnsHostnames').body["enableDnsHostnames"]
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
