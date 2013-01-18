Shindo.tests("AWS::RDS | servers", ['aws', 'rds']) do

  collection_tests(Fog::AWS[:rds].servers, rds_default_server_params) do
    @instance.wait_for { ready? }
  end
end
