  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List private gateways
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listPrivateGateways.html]
          def list_private_gateways(options={})
            options.merge!(
              'command' => 'listPrivateGateways'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
