module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a virtual router element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVirtualRouterElement.html]
        def create_virtual_router_element(nspid, options={})
          options.merge!(
            'command' => 'createVirtualRouterElement', 
            'nspid' => nspid  
          )
          request(options)
        end
      end

    end
  end
end

