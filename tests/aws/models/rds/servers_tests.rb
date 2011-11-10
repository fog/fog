Shindo.tests("AWS::RDS | servers", ['aws', 'rds']) do

  pending if Fog.mocking?

  collection_tests(Fog::AWS[:rds].servers, rds_default_server_params, false) do
    @instance.wait_for { ready? }
  end
end
