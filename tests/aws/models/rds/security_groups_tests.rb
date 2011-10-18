Shindo.tests("AWS::RDS | security groups", ['aws', 'rds']) do
  params = {:id => 'fog-test', :description => 'fog test'}

  pending if Fog.mocking?
  collection_tests(Fog::AWS[:rds].security_groups, params, false)
end
