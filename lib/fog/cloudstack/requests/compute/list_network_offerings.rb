module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available network offerings.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkOfferings.html]
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

