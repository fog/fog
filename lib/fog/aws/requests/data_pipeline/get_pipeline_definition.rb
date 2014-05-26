module Fog
  module AWS
    class DataPipeline
      class Real
        # Get pipeline definition JSON
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_GetPipelineDefinition.html
        # ==== Parameters
        # * PipelineId <~String> - The ID of the pipeline
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def get_pipeline_definition(id)
          params = {
            'pipelineId' => id,
          }

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.GetPipelineDefinition' },
          })

          Fog::JSON.decode(response.body)
        end
      end

      class Mock
        def get_pipeline_definition(id, objects)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
