module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available virtual router elements.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/listVirtualRouterElements.html]
        def list_virtual_router_elements(options={})
          options.merge!(
            'command' => 'listVirtualRouterElements'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
