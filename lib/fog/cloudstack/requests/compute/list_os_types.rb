module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all supported OS types for this cloud.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listOsTypes.html]
        def list_os_types(options={})
          options.merge!(
            'command' => 'listOsTypes'
          )
          
          request(options)
        end

      end
    end
  end
end


