Shindo.tests("AWS::Compute | key_pair", ['aws']) do

  model_tests(AWS[:compute].key_pairs, {:name => 'fogkeyname'}, true)

end
