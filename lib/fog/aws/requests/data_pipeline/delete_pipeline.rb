module Fog
  module AWS
    class DataPipeline

      class Real

        # Delete a pipeline
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_DeletePipeline.html
        # ==== Parameters
        # * PipelineId <~String> - The id of the pipeline to delete
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def delete_pipeline(id)
          params = { 'pipelineId' => id }

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.DeletePipeline' },
          })

          Fog::JSON.decode(response.body)
        end

      end

      class Mock
        def delete_pipeline(id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
