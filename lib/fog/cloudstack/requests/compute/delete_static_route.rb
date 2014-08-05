module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a static route
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteStaticRoute.html]
        def delete_static_route(id, options={})
          options.merge!(
            'command' => 'deleteStaticRoute', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

