module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a static route
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStaticRoute.html]
        def create_static_route(options={})
          options.merge!(
            'command' => 'createStaticRoute',
            'cidr' => options['cidr'], 
            'gatewayid' => options['gatewayid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

