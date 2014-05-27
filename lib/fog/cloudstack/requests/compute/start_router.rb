module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/startRouter.html]
        def start_router(options={})
          options.merge!(
            'command' => 'startRouter', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

