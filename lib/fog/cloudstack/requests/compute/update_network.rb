  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateNetwork.html]
          def update_network(options={})
            options.merge!(
              'command' => 'updateNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
