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
        def transform_objects(objects)
          objects.map { |object| JSONObject.new(object).to_api }
        end

        class JSONObject
          def initialize(object)
            @json_fields = object.clone
            @id = @json_fields.delete('id')
            @name = @json_fields.delete('name') || @id
          end

          def to_api
            {
              'id' => @id,
              'name' => @name,
              'fields' => fields
            }
          end

          private

          def fields
            @json_fields.map{|k,v| field_for_kv(k,v)}.flatten
          end

          def field_for_kv(key, value)
            if value.is_a?(Hash)
              { 'key' => key, 'refValue' => value['ref'] }

            elsif value.is_a?(Array)
              value.map { |subvalue| field_for_kv(key, subvalue) }

            else
              { 'key' => key, 'stringValue' => value }

            end
          end
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
