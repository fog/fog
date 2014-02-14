  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a static route
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteStaticRoute.html]
          def delete_static_route(options={})
            options.merge!(
              'command' => 'deleteStaticRoute'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
