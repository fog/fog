module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available networks.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listNetworks.html]
        def list_networks(options={})
          options.merge!(
            'command' => 'listNetworks'
          )
          
          request(options)
        end

      end
    end
  end
end
