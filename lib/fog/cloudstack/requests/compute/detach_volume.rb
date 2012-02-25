module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified domain.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/detachVolume.html]
        def detach_volume(id)
          options = {
            'command' => 'detachVolume',
            'id' => id
          }

          request(options)
        end

      end
    end
  end
end
