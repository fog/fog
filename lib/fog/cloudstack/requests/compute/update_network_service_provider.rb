  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a network serviceProvider of a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateNetworkServiceProvider.html]
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
