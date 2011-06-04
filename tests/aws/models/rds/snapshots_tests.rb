Shindo.tests("AWS::RDS | snapshots", ['aws', 'rds']) do

  pending if Fog.mocking?

  @server = AWS[:rds].servers.create(rds_default_server_params)
  @server.wait_for { ready? }

  params = {:id => uniq_id, :instance_id => @server.id}
  collection_tests(AWS[:rds].snapshots, params, false) do
    @instance.wait_for { ready? }
  end

  @server.destroy
end

