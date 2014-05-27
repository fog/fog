module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/stopRouter.html]
        def stop_router(options={})
          options.merge!(
            'command' => 'stopRouter', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

