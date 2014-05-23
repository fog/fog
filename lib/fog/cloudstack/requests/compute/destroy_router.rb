module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroys a router.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroyRouter.html]
        def destroy_router(options={})
          options.merge!(
            'command' => 'destroyRouter',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

