module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a static route
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createStaticRoute.html]
        def create_static_route(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createStaticRoute') 
          else
            options.merge!('command' => 'createStaticRoute', 
            'gatewayid' => args[0], 
            'cidr' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

