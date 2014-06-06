module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroys a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroyRouter.html]
        def destroy_router(id, options={})
          options.merge!(
            'command' => 'destroyRouter', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

