Shindo.tests('Fog::Compute[:aws] | security group requests', ['aws']) do

  @security_groups_format = {
    'requestId'           => String,
    'securityGroupInfo' => [{
      'groupDescription'  => String,
      'groupName'         => String,
      'ipPermissions'     => [{
        'fromPort'    => Integer,
        'groups'      => [{ 'groupName' => String, 'userId' => String }],
        'ipProtocol'  => String,
        'ipRanges'    => [],
        'toPort'      => Integer,
      }],
      'ipPermissionsEgress' => [],
      'ownerId'           => String
    }]
  }

  @owner_id = Fog::Compute[:aws].describe_security_groups('group-name' => 'default').body['securityGroupInfo'].first['ownerId']

  tests('success') do

    tests("#create_security_group('fog_security_group', 'tests group')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].create_security_group('fog_security_group', 'tests group').body
    end

    tests("#authorize_security_group_ingress('fog_security_group', {'FromPort' => 80, 'IpProtocol' => 'tcp', 'toPort' => 80})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].authorize_security_group_ingress(
        'fog_security_group',
        {
          'FromPort' => 80,
          'IpProtocol' => 'tcp',
          'ToPort' => 80,
        }
      ).body
    end

    tests("#authorize_security_group_ingress('fog_security_group', {'SourceSecurityGroupName' => 'fog_security_group', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].authorize_security_group_ingress(
        'fog_security_group',
        {
          'SourceSecurityGroupName'     => 'fog_security_group',
          'SourceSecurityGroupOwnerId'  => @owner_id
        }
      ).body
    end

    tests("#describe_security_groups").formats(@security_groups_format) do
      Fog::Compute[:aws].describe_security_groups.body
    end

    tests("#describe_security_groups('group-name' => 'fog_security_group')").formats(@security_groups_format) do
      Fog::Compute[:aws].describe_security_groups('group-name' => 'fog_security_group').body
    end

    tests("#revoke_security_group_ingress('fog_security_group', {'FromPort' => 80, 'IpProtocol' => 'tcp', 'toPort' => 80})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].revoke_security_group_ingress(
        'fog_security_group',
        {
          'FromPort' => 80,
          'IpProtocol' => 'tcp',
          'ToPort' => 80,
        }
      ).body
    end

    tests("#revoke_security_group_ingress('fog_security_group', {'SourceSecurityGroupName' => 'fog_security_group', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].revoke_security_group_ingress(
      'fog_security_group',
        {
          'GroupName'                   => 'fog_security_group',
          'SourceSecurityGroupName'     => 'fog_security_group',
          'SourceSecurityGroupOwnerId'  => @owner_id
        }
      ).body
    end

    tests("#delete_security_group('fog_security_group')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_security_group('fog_security_group').body
    end

  end
  tests('failure') do

    @security_group = Fog::Compute[:aws].security_groups.create(:description => 'tests group', :name => 'fog_security_group')

    tests("duplicate #create_security_group(#{@security_group.name}, #{@security_group.description})").raises(Fog::Compute::AWS::Error) do
      Fog::Compute[:aws].create_security_group(@security_group.name, @security_group.description)
    end

    tests("#authorize_security_group_ingress('not_a_group_name', {'FromPort' => 80, 'IpProtocol' => 'tcp', 'toPort' => 80})").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].authorize_security_group_ingress(
        'not_a_group_name',
        {
          'FromPort' => 80,
          'IpProtocol' => 'tcp',
          'ToPort' => 80,
        }
      )
    end

    tests("#authorize_security_group_ingress('not_a_group_name', {'SourceSecurityGroupName' => 'not_a_group_name', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].authorize_security_group_ingress(
        'not_a_group_name',
        {
          'SourceSecurityGroupName'     => 'not_a_group_name',
          'SourceSecurityGroupOwnerId'  => @owner_id
        }
      )
    end

    tests("#revoke_security_group_ingress('not_a_group_name', {'FromPort' => 80, 'IpProtocol' => 'tcp', 'toPort' => 80})").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].revoke_security_group_ingress(
        'not_a_group_name',
        {
          'FromPort' => 80,
          'IpProtocol' => 'tcp',
          'ToPort' => 80,
        }
      )
    end

    tests("#revoke_security_group_ingress('not_a_group_name', {'SourceSecurityGroupName' => 'not_a_group_name', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].revoke_security_group_ingress(
        'not_a_group_name',
        {
          'SourceSecurityGroupName'     => 'not_a_group_name',
          'SourceSecurityGroupOwnerId'  => @owner_id
        }
      )
    end

    tests("#delete_security_group('not_a_group_name')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].delete_security_group('not_a_group_name')
    end

    @security_group.destroy

  end

end
