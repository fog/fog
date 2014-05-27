module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists network serviceproviders for a given physical network.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkServiceProviders.html]
        def list_network_service_providers(options={})
          options.merge!(
            'command' => 'listNetworkServiceProviders'  
          )
          request(options)
        end
      end

    end
  end
end

