module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available network offerings.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listNetworkOfferings.html]
        def list_network_offerings(options={})
          options.merge!(
            'command' => 'listNetworkOfferings'
          )
          
          request(options)
        end

      end
    end
  end
end
