module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a static route
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStaticRoute.html]
        def create_static_route(cidr, gatewayid, options={})
          options.merge!(
            'command' => 'createStaticRoute', 
            'cidr' => cidr, 
            'gatewayid' => gatewayid  
          )
          request(options)
        end
      end

    end
  end
end

