Shindo.tests("AWS::Compute | volumes", ['aws']) do

  collection_tests(AWS[:compute].volumes, {:availability_zone => 'us-east-1a', :size => 1, :device => '/dev/sdz1'}, true)

end