module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a virtual router element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configureVirtualRouterElement.html]
        def configure_virtual_router_element(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configureVirtualRouterElement') 
          else
            options.merge!('command' => 'configureVirtualRouterElement', 
            'id' => args[0], 
            'enabled' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

