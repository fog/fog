Shindo.tests("AWS::DataPipeline | pipelines", ['aws', 'data_pipeline']) do

  collection_tests(Fog::AWS[:data_pipeline].servers, { id: uniq_id }) do
    @instance.wait_for { ready? }
  end
end
