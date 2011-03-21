Shindo.tests("AWS::Compute | security_group", ['aws']) do

  model_tests(AWS[:compute].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

end
