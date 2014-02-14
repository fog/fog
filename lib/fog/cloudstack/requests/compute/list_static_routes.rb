  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all static routes
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listStaticRoutes.html]
          def list_static_routes(options={})
            options.merge!(
              'command' => 'listStaticRoutes'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
