Shindo.tests("Fog::AWS[:beanstalk] | application", ['aws', 'beanstalk']) do

  pending if Fog.mocking?

  model_tests(Fog::AWS[:beanstalk].applications, {:name => uniq_id('fog-test-app')}, false)

end
