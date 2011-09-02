Shindo.tests('AWS::ACS | security group requests', ['aws', 'acs']) do

  tests('success') do
    pending if Fog.mocking?

    name = 'fog-test'
    description = 'Fog Test Group'

    tests('#create_cache_security_group').formats(AWS::ACS::Formats::SINGLE_SECURITY_GROUP) do
      body = AWS[:acs].create_cache_security_group(name, description).body
      group = body['CacheSecurityGroup']
      returns(name)        { group['CacheSecurityGroupName'] }
      returns(description) { group['Description'] }
      returns([], "no authorized security group") { group['EC2SecurityGroups'] }
      body
    end

    tests('#describe_cache_security_groups without options').formats(AWS::ACS::Formats::DESCRIBE_SECURITY_GROUPS) do
      body = AWS[:acs].describe_cache_security_groups.body
      returns(true, "has #{name}") do
        body['CacheSecurityGroups'].any? {|group| group['CacheSecurityGroupName'] == name }
      end
      body
    end

    tests('#describe_cache_security_groups with name').formats(AWS::ACS::Formats::DESCRIBE_SECURITY_GROUPS) do
      body = AWS[:acs].describe_cache_security_groups('CacheSecurityGroupName' => name).body
      returns(1, "size of 1") { body['CacheSecurityGroups'].size }
      returns(name, "has #{name}") { body['CacheSecurityGroups'].first['CacheSecurityGroupName'] }
      body
    end

    tests('authorization') do
      ec2_group = Fog::Compute.new(:provider => 'AWS').security_groups.create(:name => 'fog-test-acs', :description => 'Fog Test ACS')
      # Reload to get the owner_id
      ec2_group.reload

      tests('#authorize_cache_security_group_ingress').formats(AWS::ACS::Formats::SINGLE_SECURITY_GROUP) do
        body = AWS[:acs].authorize_cache_security_group_ingress(name, ec2_group.name, ec2_group.owner_id).body
        group = body['CacheSecurityGroup']
        expected_ec2_groups = [{'Status' => 'authorizing', 'EC2SecurityGroupName' => ec2_group.name, 'EC2SecurityGroupOwnerId' => ec2_group.owner_id}]
        returns(expected_ec2_groups, 'has correct EC2 groups') { group['EC2SecurityGroups'] }
        body
      end

      # Wait for the state to be active
      Fog.wait_for do
        group = AWS[:acs].describe_cache_security_groups('CacheSecurityGroupName' => name).body['CacheSecurityGroups'].first
        group['EC2SecurityGroups'].all? {|ec2| ec2['Status'] == 'authorized'}
      end

      tests('#revoke_cache_security_group_ingress').formats(AWS::ACS::Formats::SINGLE_SECURITY_GROUP) do
        body = AWS[:acs].revoke_cache_security_group_ingress(name, ec2_group.name, ec2_group.owner_id).body
        group = body['CacheSecurityGroup']
        expected_ec2_groups = [{'Status' => 'revoking', 'EC2SecurityGroupName' => ec2_group.name, 'EC2SecurityGroupOwnerId' => ec2_group.owner_id}]
        returns(expected_ec2_groups, 'has correct EC2 groups') { group['EC2SecurityGroups'] }
        body
      end


      ec2_group.destroy
    end

    tests('#delete_cache_security_group').formats(AWS::ACS::Formats::BASIC) do
      body = AWS[:acs].delete_cache_security_group(name).body
    end
  end

  tests('failure') do
    # TODO:
    # Create a duplicate security group
    # List a missing security group
    # Delete a missing security group
  end
end
