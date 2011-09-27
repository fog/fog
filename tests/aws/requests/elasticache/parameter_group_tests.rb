Shindo.tests('AWS::Elasticache | parameter group requests', ['aws', 'elasticache']) do

  tests('success') do
    pending if Fog.mocking?

    name = 'fog-test'
    description = 'Fog Test Parameter Group'

    tests(
    '#create_cache_parameter_group'
    ).formats(AWS::Elasticache::Formats::SINGLE_PARAMETER_GROUP) do
      body = AWS[:elasticache].create_cache_parameter_group(name, description).body
      group = body['CacheParameterGroup']
      returns(name)           { group['CacheParameterGroupName'] }
      returns(description)    { group['Description'] }
      returns('memcached1.4') { group['CacheParameterGroupFamily'] }
      body
    end

    tests(
    '#describe_cache_parameter_groups without options'
    ).formats(AWS::Elasticache::Formats::DESCRIBE_PARAMETER_GROUPS) do
      body = AWS[:elasticache].describe_cache_parameter_groups.body
      returns(true, "has #{name}") do
        body['CacheParameterGroups'].any? do |group|
          group['CacheParameterGroupName'] == name
        end
      end
      body
    end
    
    tests(
    '#describe_cache_parameter_groups with name'
    ).formats(AWS::Elasticache::Formats::DESCRIBE_PARAMETER_GROUPS) do
      body = AWS[:elasticache].describe_cache_parameter_groups(name).body
      returns(1, "size of 1") { body['CacheParameterGroups'].size }
      returns(name, "has #{name}") do
        body['CacheParameterGroups'].first['CacheParameterGroupName']
      end
      body
    end
    
    tests(
    '#delete_cache_parameter_group'
    ).formats(AWS::Elasticache::Formats::BASIC) do
      body = AWS[:elasticache].delete_cache_parameter_group(name).body
    end
  end

  tests('failure') do
    # TODO:
    # Create a duplicate parameter group
    # List a missing parameter group
    # Delete a missing parameter group
  end
end

