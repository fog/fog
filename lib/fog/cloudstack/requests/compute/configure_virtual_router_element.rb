module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a virtual router element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureVirtualRouterElement.html]
        def configure_virtual_router_element(id, enabled, options={})
          options.merge!(
            'command' => 'configureVirtualRouterElement', 
            'id' => id, 
            'enabled' => enabled  
          )
          request(options)
        end
      end

    end
  end
end

