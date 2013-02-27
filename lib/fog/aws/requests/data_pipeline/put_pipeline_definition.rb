module Fog
  module AWS
    class DataPipeline

      class Real

        # Put raw pipeline definition JSON
        # http://docs.aws.amazon.com/datapipeline/latest/APIReference/API_PutPipelineDefinition.html
        # ==== Parameters
        # * PipelineId <~String> - The ID of the pipeline
        # * PipelineObjects <~String> - Objects in the pipeline
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def put_pipeline_definition(id, objects)
          params = {
            'pipelineId' => id,
            'pipelineObjects' => transform_objects(objects),
          }

          response = request({
            :body => Fog::JSON.encode(params),
            :headers => { 'X-Amz-Target' => 'DataPipeline.PutPipelineDefinition' },
          })

          Fog::JSON.decode(response.body)
        end

        # Take a list of pipeline object hashes as specified in the Data Pipeline JSON format
        # and transform it into the format expected by the API
        private
        def transform_objects(objects)
          output = []

          objects.each do |object|
            new_object = {}
            new_object['id'] = object.delete('id')
            new_object['name'] = object.delete('name') || new_object['id']

            new_object['fields'] = []
            object.each do |key, value|
              if value.is_a?(Hash)
                new_object['fields'] << { 'key' => key, 'refValue' => value['ref'] }

              elsif value.is_a?(Array)
                value.each do |v|
                  new_object['fields'] << { 'key' => key, 'stringValue' => v }
                end

              else
                new_object['fields'] << { 'key' => key, 'stringValue' => value }

              end
            end

            output << new_object
          end

          output
        end

      end

      class Mock
        def put_pipeline_definition(id, objects)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
