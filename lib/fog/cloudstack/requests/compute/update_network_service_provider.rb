module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a network serviceProvider of a physical network
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/updateNetworkServiceProvider.html]
        def update_network_service_provider(options={})
          options.merge!(
            'command' => 'updateNetworkServiceProvider'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
