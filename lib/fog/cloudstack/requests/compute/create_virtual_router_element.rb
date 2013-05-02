  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Create a virtual router element.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVirtualRouterElement.html]
          def create_virtual_router_element(options={})
            options.merge!(
              'command' => 'createVirtualRouterElement'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
