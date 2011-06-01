Shindo.tests("AWS::RDS | security groups", ['aws', 'rds']) do
  params = {:id => 'fog-test', :description => 'fog test'}

  collection_tests(AWS[:rds].security_groups, params, false)
end
