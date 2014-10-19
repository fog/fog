module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/startRouter.html]
        def start_router(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'startRouter') 
          else
            options.merge!('command' => 'startRouter', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

