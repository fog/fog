module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a virtual router element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureVirtualRouterElement.html]
        def configure_virtual_router_element(options={})
          options.merge!(
            'command' => 'configureVirtualRouterElement',
            'enabled' => options['enabled'], 
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

