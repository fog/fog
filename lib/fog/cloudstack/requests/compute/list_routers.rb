module Fog
  module Compute
    class Cloudstack

      class Real
        # List routers.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listRouters.html]
        def list_routers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listRouters') 
          else
            options.merge!('command' => 'listRouters')
          end
          request(options)
        end
      end

    end
  end
end

