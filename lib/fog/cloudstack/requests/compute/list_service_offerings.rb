module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available service offerings.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listServiceOfferings.html]
        def list_service_offerings(options={})
          options.merge!(
            'command' => 'listServiceOfferings'
          )
          
          request(options)
        end

      end
    end
  end
end
