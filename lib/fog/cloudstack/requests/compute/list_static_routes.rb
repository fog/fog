module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all static routes
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listStaticRoutes.html]
        def list_static_routes(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listStaticRoutes') 
          else
            options.merge!('command' => 'listStaticRoutes')
          end
          request(options)
        end
      end

    end
  end
end

