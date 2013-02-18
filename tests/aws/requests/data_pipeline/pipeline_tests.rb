Shindo.tests('AWS::DataPipeline | pipeline_tests', ['aws', 'data_pipeline']) do
  pending if Fog.mocking?

  @pipeline_id = nil

  tests('success') do
    tests("#create_pipeline").formats(AWS::DataPipeline::Formats::BASIC) do
      unique_id = 'fog-test-pipeline-unique-id'
      name = 'fog-test-pipeline-name'
      description = 'Fog test pipeline'

      result = Fog::AWS[:data_pipeline].create_pipeline(unique_id, name, description)
      @pipeline_id = result['pipelineId']
      result
    end

    tests("#list_pipelines").formats(AWS::DataPipeline::Formats::LIST_PIPELINES) do
      Fog::AWS[:data_pipeline].list_pipelines()
    end

    tests("#describe_pipelines").formats(AWS::DataPipeline::Formats::DESCRIBE_PIPELINES) do
      ids = [@pipeline_id]
      Fog::AWS[:data_pipeline].describe_pipelines(ids)
    end

    tests("#put_pipeline_definition").formats(AWS::DataPipeline::Formats::PUT_PIPELINE_DEFINITION) do
      objects = [
        {
          "id" => "Nightly",
          "type" => "Schedule",
          "startDateTime" => Time.now.strftime("%Y-%m-%dT%H:%M:%S"),
          "period" => "24 hours",
        },
        {
          "id" => "Default",
          "role" => "role-dumps",
          "resourceRole" => "role-dumps-inst",
          "schedule" => { "ref" => "Nightly" },
        },
      ]

      Fog::AWS[:data_pipeline].put_pipeline_definition(@pipeline_id, objects)
    end

    tests("#activate_pipeline") do
      Fog::AWS[:data_pipeline].activate_pipeline(@pipeline_id)
    end

    tests("#delete_pipeline") do
      Fog::AWS[:data_pipeline].delete_pipeline(@pipeline_id)
    end

  end
end
