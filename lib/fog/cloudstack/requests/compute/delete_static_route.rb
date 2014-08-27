module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a static route
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteStaticRoute.html]
        def delete_static_route(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteStaticRoute') 
          else
            options.merge!('command' => 'deleteStaticRoute', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

