  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds a network serviceProvider to a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addNetworkServiceProvider.html]
          def add_network_service_provider(options={})
            options.merge!(
              'command' => 'addNetworkServiceProvider'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
