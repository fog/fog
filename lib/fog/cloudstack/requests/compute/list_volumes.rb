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

      end
    end
  end
end
