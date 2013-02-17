Shindo.tests("AWS::DataPipeline | pipelines", ['aws', 'data_pipeline']) do

  model_tests(Fog::AWS[:data_pipeline].pipelines, { id: uniq_id }) do
    @instance.wait_for { ready? }
  end
end
