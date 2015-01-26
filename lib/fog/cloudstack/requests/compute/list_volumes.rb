module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all volumes.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVolumes.html]
        def list_volumes(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVolumes')
          else
            options.merge!('command' => 'listVolumes')
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

      class Mock
        def list_volumes(options={})
          volume_id = options.delete('id')
          if volume_id
            volumes = [self.data[:volumes][volume_id]]
          else
            volumes = self.data[:volumes].values
          end

          {
            'listvolumesresponse' => {
              'count' => volumes.size,
              'volume' => volumes
            }
          }
        end
      end
    end
  end
end

