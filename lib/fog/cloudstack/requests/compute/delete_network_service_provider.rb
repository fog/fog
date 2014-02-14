  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Network Service Provider.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNetworkServiceProvider.html]
          def delete_network_service_provider(options={})
            options.merge!(
              'command' => 'deleteNetworkServiceProvider'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
