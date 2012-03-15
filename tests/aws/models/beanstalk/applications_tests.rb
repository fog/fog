Shindo.tests("Fog::AWS[:beanstalk] | applications", ['aws', 'beanstalk']) do

  collection_tests(Fog::AWS[:beanstalk].applications, {:name => uniq_id('fog-test-app')}, false)

end