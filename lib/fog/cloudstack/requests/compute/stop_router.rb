  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Stops a router.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/stopRouter.html]
          def stop_router(options={})
            options.merge!(
              'command' => 'stopRouter'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
