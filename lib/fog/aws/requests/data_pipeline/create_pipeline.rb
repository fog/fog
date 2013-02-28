module Fog
  module AWS
    class DataPipeline

      class Real

        # Create a pipeline
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_CreatePipeline.html
        # ==== Parameters
        # * UniqueId <~String> - A unique ID for of the pipeline
        # * Name <~String> - The name of the pipeline
        # * Description <~String> - Description of the pipeline
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_pipeline(unique_id, name, description=nil)
          params = {
            'uniqueId' => unique_id,
            'name' => name,
          }
          params['Description'] = description if description

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.CreatePipeline' },
          })

          Fog::JSON.decode(response.body)
        end

      end

      class Mock
        def create_pipeline(unique_id, name, description=nil)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
