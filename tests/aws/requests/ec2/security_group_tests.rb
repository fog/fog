Shindo.tests('AWS::EC2 | security group requests', ['aws']) do

  @owner_id = AWS[:ec2].describe_security_groups('default').body['securityGroupInfo'].first['ownerId']

  tests('success') do

    tests("#create_security_group('fog_security_group', 'tests group')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].create_security_group('fog_security_group', 'tests group').body
    end

    tests("#authorize_security_group_ingress({'FromPort' => 80, 'GroupName' => 'fog_security_group', 'IpProtocol' => 'tcp', 'toPort' => 80})").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].authorize_security_group_ingress({
        'FromPort' => 80,
        'GroupName' => 'fog_security_group',
        'IpProtocol' => 'tcp',
        'ToPort' => 80,
      }).body
    end

    tests("#authorize_security_group_ingress({'GroupName' => 'fog_security_group', 'SourceSecurityGroupName' => 'fog_security_group', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].authorize_security_group_ingress({
        'GroupName'                   => 'fog_security_group',
        'SourceSecurityGroupName'     => 'fog_security_group',
        'SourceSecurityGroupOwnerId'  => @owner_id
      }).body
    end

    tests("#describe_security_groups").formats(AWS::EC2::Formats::SECURITY_GROUPS) do
      AWS[:ec2].describe_security_groups.body
    end

    tests("#describe_security_groups('fog_security_group')").formats(AWS::EC2::Formats::SECURITY_GROUPS) do
      AWS[:ec2].describe_security_groups('fog_security_group').body
    end

    tests("#revoke_security_group_ingress({'FromPort' => 80, 'GroupName' => 'fog_security_group', 'IpProtocol' => 'tcp', 'toPort' => 80})").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].revoke_security_group_ingress({
        'FromPort' => 80,
        'GroupName' => 'fog_security_group',
        'IpProtocol' => 'tcp',
        'ToPort' => 80,
      }).body
    end

    tests("#revoke_security_group_ingress({'GroupName' => 'fog_security_group', 'SourceSecurityGroupName' => 'fog_security_group', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].revoke_security_group_ingress({
        'GroupName'                   => 'fog_security_group',
        'SourceSecurityGroupName'     => 'fog_security_group',
        'SourceSecurityGroupOwnerId'  => @owner_id
      }).body
    end

    tests("#delete_security_group('fog_security_group')").formats(AWS::EC2::Formats::BASIC) do
      AWS[:ec2].delete_security_group('fog_security_group').body
    end

  end
  tests('failure') do

    @security_group = AWS[:ec2].security_groups.create(:description => 'tests group', :name => 'fog_security_group')

    tests("duplicate #create_security_group(#{@security_group.name}, #{@security_group.description})").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].create_security_group(@security_group.name, @security_group.description)
    end

    tests("#authorize_security_group_ingress({'FromPort' => 80, 'GroupName' => 'not_a_group_name', 'IpProtocol' => 'tcp', 'toPort' => 80})").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].authorize_security_group_ingress({
        'FromPort' => 80,
        'GroupName' => 'not_a_group_name',
        'IpProtocol' => 'tcp',
        'ToPort' => 80,
      })
    end

    tests("#authorize_security_group_ingress({'GroupName' => 'not_a_group_name', 'SourceSecurityGroupName' => 'not_a_group_name', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].authorize_security_group_ingress({
        'GroupName'                   => 'not_a_group_name',
        'SourceSecurityGroupName'     => 'not_a_group_name',
        'SourceSecurityGroupOwnerId'  => @owner_id
      })
    end

    tests("#describe_security_group('not_a_group_name)").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_security_groups('not_a_group_name')
    end

    tests("#revoke_security_group_ingress({'FromPort' => 80, 'GroupName' => 'not_a_group_name', 'IpProtocol' => 'tcp', 'toPort' => 80})").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].revoke_security_group_ingress({
        'FromPort' => 80,
        'GroupName' => 'not_a_group_name',
        'IpProtocol' => 'tcp',
        'ToPort' => 80,
      })
    end

    tests("#revoke_security_group_ingress({'GroupName' => 'not_a_group_name', 'SourceSecurityGroupName' => 'not_a_group_name', 'SourceSecurityGroupOwnerId' => '#{@owner_id}'})").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].revoke_security_group_ingress({
        'GroupName'                   => 'not_a_group_name',
        'SourceSecurityGroupName'     => 'not_a_group_name',
        'SourceSecurityGroupOwnerId'  => @owner_id
      })
    end

    tests("#delete_security_group('not_a_group_name')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].delete_security_group('not_a_group_name')
    end

    @security_group.destroy

  end

end
