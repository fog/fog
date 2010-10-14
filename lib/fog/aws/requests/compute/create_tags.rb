module Fog
  module AWS
    class Compute
      class Real

        # Adds tags to resources
        #
        # ==== Parameters
        # * resources<~String> - One or more resources to tag
        # * tags<~String> - hash of key value tag pairs to assign
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def create_tags(resources, tags)
          resources = [*resources]
          for key, value in tags
            if value.nil?
              tags[key] = ''
            end
          end
          params = {}
          params.merge!(AWS.indexed_param('ResourceId', resources))
          params.merge!(AWS.indexed_param('Tag.%d.Key', tags.keys))
          params.merge!(AWS.indexed_param('Tag.%d.Value', tags.values))
          request({
            'Action'            => 'CreateTags',
            :parser             => Fog::Parsers::AWS::Compute::Basic.new
          }.merge!(params))
        end

      end

      class Mock

        def create_tags(resources, tags)
          response = Excon::Response.new
          resources = [*resources]
          resource_tags = {}
          objects = resources.map do |resource_id|
            if resource = @data[:instances][resource_id]
              [resource, 'instance']
            elsif resource = @data[:images][resource_id]
              [resource, 'image']
            elsif resource = @data[:volumes][resource_id]
              [resource, 'volume']
            elsif resource = @data[:snapshots][resource_id]
              [resource, 'snapshot']
            end
          end
        
          if objects.all?
            response.status = 200
            @data[:tags] ||= []
            tags.each do |key, value|
              resources.each_with_index do |resource_id, i|
                object, resource_type = objects[i]
                object['tagSet'] ||= {}
                object['tagSet'][key] = value
                @data[:tags] << {
                  'key' => key,
                  'value' => value,
                  'resourceId' => resource_id,
                  'resourceType' => resource_type
                }
              end
            end
            
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return' => 'true'
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
        
      end
      
    end
  end
end
