module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists network serviceproviders for a given physical network.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/listNetworkServiceProviders.html]
        def list_network_service_providers(options={})
          options.merge!(
            'command' => 'listNetworkServiceProviders'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
