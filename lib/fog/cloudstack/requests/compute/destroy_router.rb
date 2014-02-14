  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Destroys a router.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/destroyRouter.html]
          def destroy_router(options={})
            options.merge!(
              'command' => 'destroyRouter'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
