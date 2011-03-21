Shindo.tests("AWS::Compute | key_pairs", ['aws']) do

  collection_tests(AWS[:compute].key_pairs, {:name => 'fogkeyname'}, true)

end