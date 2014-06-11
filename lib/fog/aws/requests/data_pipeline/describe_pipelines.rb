module Fog
  module AWS
    class DataPipeline
      class Real
        # Describe pipelines
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_DescribePipelines.html
        # ==== Parameters
        # * PipelineIds <~String> - ID of pipeline to retrieve information for
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_pipelines(ids)
          params = {}
          params['pipelineIds'] = ids

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.DescribePipelines' },
          })

          Fog::JSON.decode(response.body)
        end
      end

      class Mock
        def describe_pipelines(ids)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
