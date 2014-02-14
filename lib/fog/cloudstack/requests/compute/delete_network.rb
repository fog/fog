  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNetwork.html]
          def delete_network(options={})
            options.merge!(
              'command' => 'deleteNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
