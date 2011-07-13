Shindo.tests('AWS::ACS | security groups', ['aws', 'acs']) do
  group_name = 'fog-test'
  description = 'Fog Test'

  pending if Fog.mocking?

  model_tests(AWS[:acs].security_groups, {:id => group_name, :description => description}, false) do
    # TODO:
    # test authorize_ec2_group
    # test revoke_ec2_group
  end

  collection_tests(AWS[:acs].security_groups, {:id => group_name, :description => description}, false)
end
