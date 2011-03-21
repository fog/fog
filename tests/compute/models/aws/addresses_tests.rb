Shindo.tests("AWS::Compute | addresses", ['aws']) do

  collection_tests(AWS[:compute].addresses, {}, true)

end