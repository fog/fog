module Fog
  module AWS
    class DataPipeline
      class Real
        # List all pipelines
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_ListPipelines.html
        # ==== Parameters
        # * Marker <~String> - The starting point for the results to be returned.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def list_pipelines(options={})
          params = {}
          params['Marker'] = options[:marker] if options[:marker]

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.ListPipelines' },
          })

          Fog::JSON.decode(response.body)
        end
      end

      class Mock
        def list_pipelines(options={})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
