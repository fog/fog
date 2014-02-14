  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a private gateway
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createPrivateGateway.html]
          def create_private_gateway(options={})
            options.merge!(
              'command' => 'createPrivateGateway'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
