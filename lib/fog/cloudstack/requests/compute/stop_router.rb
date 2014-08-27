module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/stopRouter.html]
        def stop_router(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'stopRouter') 
          else
            options.merge!('command' => 'stopRouter', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

