Shindo.tests("AWS::Compute | security_groups", ['aws']) do

  collection_tests(AWS[:compute].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

end
