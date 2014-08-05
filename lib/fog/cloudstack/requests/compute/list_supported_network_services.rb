module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all network services provided by CloudStack or for the given Provider.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSupportedNetworkServices.html]
        def list_supported_network_services(options={})
          options.merge!(
            'command' => 'listSupportedNetworkServices'  
          )
          request(options)
        end
      end

    end
  end
end

