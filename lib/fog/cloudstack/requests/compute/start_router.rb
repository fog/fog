  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Starts a router.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/startRouter.html]
          def start_router(options={})
            options.merge!(
              'command' => 'startRouter'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
