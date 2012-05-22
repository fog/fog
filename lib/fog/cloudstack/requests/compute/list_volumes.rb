module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all volumes.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listVolumes.html]
        def list_volumes(options={})
          options.merge!(
            'command' => 'listVolumes'
          )

          request(options)
        end

      end # Real

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
      end # Mock
    end # Cloudstack
  end # Compute
end #Fog
