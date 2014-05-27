module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available virtual router elements.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVirtualRouterElements.html]
        def list_virtual_router_elements(options={})
          options.merge!(
            'command' => 'listVirtualRouterElements'  
          )
          request(options)
        end
      end

    end
  end
end

