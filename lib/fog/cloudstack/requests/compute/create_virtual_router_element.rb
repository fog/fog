module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a virtual router element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVirtualRouterElement.html]
        def create_virtual_router_element(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVirtualRouterElement') 
          else
            options.merge!('command' => 'createVirtualRouterElement', 
            'nspid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

