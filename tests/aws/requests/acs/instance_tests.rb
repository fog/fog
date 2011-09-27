Shindo.tests('AWS::ACS | instance requests', ['aws', 'acs']) do

  @security_group_name = 'fog-test'
  @security_group_description = 'Fog Test Group'
  tests('success') do
    pending if Fog.mocking?

    tests('#create_cache_security_group').formats(AWS::ACS::Formats::CREATE_SECURITY_GROUP) do
      body = AWS[:acs].create_cache_security_group(@security_group_name, @security_group_description).body
      returns(@security_group_name)        { body['CacheSecurityGroup']['CacheSecurityGroupName'] }
      returns(@security_group_description) { body['CacheSecurityGroup']['CacheSecurityGroupDescription'] }
      body
    end
  end
end
