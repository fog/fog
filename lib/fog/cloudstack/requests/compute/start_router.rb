module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/startRouter.html]
        def start_router(id, options={})
          options.merge!(
            'command' => 'startRouter', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

