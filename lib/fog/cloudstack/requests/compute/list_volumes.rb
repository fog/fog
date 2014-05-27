module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all volumes.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVolumes.html]
        def list_volumes(options={})
          options.merge!(
            'command' => 'listVolumes'  
          )
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

