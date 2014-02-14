  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Private gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deletePrivateGateway.html]
          def delete_private_gateway(options={})
            options.merge!(
              'command' => 'deletePrivateGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
